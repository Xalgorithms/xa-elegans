require 'rails_helper'

require 'xa/ubl/invoice'

describe InvoiceParseService do
  include XA::UBL::Invoice
  
  it 'should parse existing documents' do
    src = IO.read('./ubl/documents/UBL-Invoice-2.1-Example.xml')
    doc = Document.create(src: src)
    InvoiceParseService.parse(doc.id)

    doc = Document.find(doc.id)
    expect(doc.content).to_not be_nil
    parse(src) do |content|
      ex_doc = Document.create(content: content)
      expect(doc.content).to eql(ex_doc.content)
    end
  end
end
