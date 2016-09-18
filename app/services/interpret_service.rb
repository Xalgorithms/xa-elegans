require 'xa/registry/client'
require 'xa/rules/context'
require 'xa/rules/interpret'
require 'xa/transforms/interpret'
require 'xa/util/documents'

class InterpretService
  class Documents
    include XA::Util::Documents
  end
  
  class RuleInterpreter
    include XA::Rules::Interpret
  end

  class TransformInterpreter
    include XA::Transforms::Interpret
  end
  
  def self.execute(invoice_id, rule_id, transform_id)
    get_latest_invoice_revision(invoice_id) do |doc|
      download_rule(rule_id) do |rule, rm|
        build_tables_from_transform(doc, transform_id) do |tables|
          ctx = XA::Rules::Context.new(tables, Rails.logger)

          tables = ctx.execute(rule).tables
          reverse_transform_and_merge(transform_id, doc, tables) do |content, new_content|
            dm = Document.create(content: content)
            chm = Change.create(document: dm, content: new_content, rule: rm)
            Revision.create(invoice_id: invoice_id, document: dm)
          end
        end
      end
    end
  end

  private

  def self.get_latest_invoice_revision(invoice_id)
    im = Invoice.find(invoice_id)
    yield(im.revisions.last.document.content) if im.revisions.length > 0

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find invoice (id=#{invoice_id})")
  end
  
  def self.download_rule(rule_id)
    rm = Rule.find(rule_id)

    url = Rails.configuration.xa['registry']['url']
    Rails.logger.info("> downloading rule from registry (rule=#{rm.public_id}; url=#{url})")
    cl = XA::Registry::Client.new(url)
    rule_content = cl.rule_by_full_reference(rm.reference)
    if rule_content
      Rails.logger.info("> got a valid rule, yielding with interpretation")
      yield(RuleInterpreter.new.interpret(rule_content), rm)
    else
      Rails.logger.error("! failed to download the rule")
    end

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find rule (id=#{rule_id})")
  end

  def self.build_tables_from_transform(document, transform_id)
    Rails.logger.info("> building tables (transform=#{transform_id})")

    txm = Transformation.find(transform_id)

    shared_content = document.except('lines')
    document_table = document.fetch('lines', []).map do |ln|
      shared_content.merge(ln)
    end
    yield(TransformInterpreter.new.interpret(document_table, txm.content['tables']))
    
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find transformation (id=#{transform_id})")    
  end

  def self.reverse_transform_and_merge(transform_id, doc, tables)
    docs = Documents.new
    txm = Transformation.find(transform_id)

    Rails.logger.info("> reversing transformation (tables=#{tables})")
    
    all_content = TransformInterpreter.new.misinterpret(tables, txm.content['tables'])
  # search through all_content to determine fields that should appear in shared_content
    shared_content = all_content.inject({}) do |sc, d|
      it_shared_content = d.keys.inject({}) do |itsc, k|
        docs.document_contains_path(doc, k) ? docs.combine_documents([itsc, { k => d[k] }]) : itsc
      end
      docs.combine_documents([sc, it_shared_content])
    end

 # search through and find all lines content
    lines_content = all_content.map do |d|
      d.keys.inject({}) do |lc, k|
        !docs.document_contains_path(doc, k) ? lc.merge(k => d[k]) : lc
      end
    end

    # create a new document
    new_content = shared_content.merge('lines' => lines_content)
    yield(docs.combine_documents([doc, new_content]), new_content)
    
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("! failed to find transformation (id=#{transform_id})")        
  end
end
