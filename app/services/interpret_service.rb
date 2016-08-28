require 'xa/registry/client'
require 'xa/rules/context'
require 'xa/rules/interpret'
require 'xa/transforms/interpret'

class InterpretService
  class RuleInterpreter
    include XA::Rules::Interpret
  end

  class TransformInterpreter
    include XA::Transforms::Interpret
  end
  
  def self.execute(invoice_id, rule_id, transform_id)
    rv = nil

    get_latest_invoice_revision(invoice_id) do |doc|
      download_rule(rule_id) do |rule|
        build_tables_from_transform(doc, transform_id) do |tables|
          ctx = XA::Rules::Context.new(tables)

          # temporary - see spec for details
          rv = ctx.execute(rule).tables
        end
      end
    end

    rv
  end

  private

  def self.get_latest_invoice_revision(invoice_id)
    im = Invoice.find(invoice_id)
    yield(im.document.content)

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find invoice (id=#{invoice_id})")
  end
  
  def self.download_rule(rule_id)
    rm = Rule.find(rule_id)
    cl = XA::Registry::Client.new(Rails.configuration.xa['registry']['url'])
    rule_content = cl.rule_by_full_reference(rm.reference)

    yield(RuleInterpreter.new.interpret(rule_content))

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find rule (id=#{rule_id})")
  end

  def self.build_tables_from_transform(document, transform_id)
    txm = Transformation.find(transform_id)
    shared_content = document.except('lines')
    document_table = document.fetch('lines', []).map do |ln|
      shared_content.merge(ln)
    end
    yield(TransformInterpreter.new.interpret(document_table, txm.content['tables']))
    
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find transformation (id=#{transform_id})")    
  end
end
