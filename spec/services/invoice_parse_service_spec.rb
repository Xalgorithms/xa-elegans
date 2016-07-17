require 'rails_helper'

require 'ubl/invoice'

describe InvoiceParseService do
  include UBL::Invoice
  
  it 'should parse existing documents' do
    src = IO.read('./ubl/documents/UBL-Invoice-2.1-Example.xml')
    doc = Document.create(src: src)
    InvoiceParseService.parse(doc.id)

    doc = Document.find(doc.id)
    expect(doc.content).to_not be_nil
    parse(src) do |content|
      expect(doc.content).to eql(content.with_indifferent_access)
    end
  end
end
