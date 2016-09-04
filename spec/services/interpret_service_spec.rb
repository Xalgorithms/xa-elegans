require 'rails_helper'

require 'xa/registry/client'
require 'xa/rules/context'
require 'xa/rules/interpret'
require 'xa/transforms/interpret'

describe InterpretService do
  after(:all) do
    Association.destroy_all
    Invoice.destroy_all
    Rule.destroy_all
    Transformation.destroy_all
    Document.destroy_all
    Invoice.destroy_all
    Revision.destroy_all
  end

  let(:transform_interpreter) do
    Class.new do
      include XA::Transforms::Interpret
    end.new
  end

  let(:rule_interpreter) do
    Class.new do
      include XA::Rules::Interpret
    end.new
  end

  def prepare_expected_tables(document, transform)
    # the document will be arranged into a basic tables according to the number of lines
    shared_content = document.except('lines')
    document_table = document.fetch('lines', []).map do |ln|
      shared_content.merge(ln)
    end

    transform_interpreter.interpret(document_table, transform['tables'])
  end
  
  it 'should interpret a single rule/transform' do
    # this is the basic invoice structure expected for interpretation
    # for each line, the interpret module will be provided with data
    # that includes each :line merged with the outer part of the invoice
    document_content = {
      'a' => 1,
      'b' => 2,
      'c' => 3,
      'lines' => [
        {
          'l0' => '00',
          'l1' => '01',
        },
        {
          'l0' => '10',
          'l1' => '11',
        },
      ],
    }

    transform_content = {
      'adapts' => 'invoice',
      'tables' => {
        'one' => {
          'p' => 'l0',
          'q' => 'b',
        },
        'two' => {
          'y' => 'l1',
          'z' => 'a',
        },
      },
    }

    rule_content = {
      'meta' => {
        'expects' => {
          'one' => ['p', 'q'],
          'two' => ['y', 'z'],
        }
      },
      'actions' => [
        {
          'name' => 'push',
          'table' => 'one',
        },
        {
          'name' => 'push',
          'table' => 'two',
        },
        {
          'name'  => 'commit',
          'table' => 'result',
        },
      ],
    }

    ams = rand_array_of_models(:association)
    ams.each do |am|
      am.update_attributes(rule: create(:rule), transformation: create(:transformation, content: transform_content))
    end

    ams.each do |am|
      ims = rand_array_of_models(:invoice)

      ims.each do |im|
        cl = double(XA::Registry::Client)
        
        revm = create(:revision, invoice: im, document: create(:document, content: document_content))

        tables = prepare_expected_tables(document_content, transform_content)
        rule = rule_interpreter.interpret(rule_content)
        ctx = XA::Rules::Context.new(tables)
        result_tables = ctx.execute(rule).tables

        # expect a client to request the Rule - return a real Rule that can be interpreted - but intercept Rule.new
        expect(cl).to receive(:rule_by_full_reference).with(am.rule.reference).and_return(rule_content)
        expect(XA::Registry::Client).to receive(:new).with(Rails.configuration.xa['registry']['url']).and_return(cl)

        # FIX: artifical - after updates to xa-rules and Document, there should be a new Document formed
        old_len = im.revisions.length
        odm = im.revisions.last.document

        InterpretService.execute(im.id, am.rule.id, am.transformation.id)
        
        im = Invoice.find(im.id)

        expect(im.revisions.length).to eql(old_len + 1)
        ndm = im.revisions.last.document
        expect(ndm.id).to_not eql(odm.id)

        # the rule didn't update anything, so the content should be equivalent
        expect(ndm.content).to eql(odm.content)
      end
    end    
  end
end
