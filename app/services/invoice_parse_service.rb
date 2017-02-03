require 'xa/ubl/invoice'

class InvoiceParseService
  include XA::UBL::Invoice    
  
  def self.parse(document_id)
    doc = Document.find(document_id)
    new.parse(doc.src) do |content|
      doc.update_attributes(content: content)
    end if doc.src
  end
end
