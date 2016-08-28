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

    ams = rand_array_of_models(:association).map do |am|
      am.rule = create(:rule)

      am.transformation = create(:transformation, content: transform_content)
      am
    end

    ims = rand_array_of_models(:invoice).map do |im|
      im.update_attributes(document: create(:document, content: document_content))
      im
    end

    ams.each do |am|
      ims.each do |im|
        cl = double(XA::Registry::Client)
        
        tables = prepare_expected_tables(document_content, transform_content)
        rule = rule_interpreter.interpret(rule_content)
        ctx = XA::Rules::Context.new(tables)
        result_tables = ctx.execute(rule).tables

        # expect a client to request the Rule - return a real Rule that can be interpreted - but intercept Rule.new
        expect(cl).to receive(:rule_by_full_reference).with(am.rule.reference).and_return(rule_content)
        expect(XA::Registry::Client).to receive(:new).with(Rails.configuration.xa['registry']['url']).and_return(cl)

        # FIX: artifical - after updates to xa-rules and Document, there should be a new Document formed
        actual_tables = InterpretService.execute(im.id, am.rule.id, am.transformation.id)
        expect(actual_tables).to eql(result_tables)
      end
    end    
  end
end
