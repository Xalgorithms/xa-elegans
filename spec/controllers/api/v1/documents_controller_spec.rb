require 'rails_helper'

describe Api::V1::DocumentsController, type: :controller do
  include Randomness
  include ResponseJson

  it 'should receive documents' do
    len = Document.all.count
    content = IO.read('./ubl/documents/UBL-Invoice-2.1-Example.xml')

    parse_document_id = nil
    expect(InvoiceParseService).to receive(:parse) do |document_id|
      parse_document_id = document_id
    end

    post(:create, content)
    
    expect(Document.all.count).to eql(len + 1)
    doc = Document.last
    expect(doc).to_not be_nil
    expect(doc.src).to_not be_nil

    expect(response_json).to eql(encode_decode(id: doc.public_id))

    expect(parse_document_id).to eql(doc.id)
  end

  it 'should show content of an existing document' do
    rand_array_of_models(:document).each do |dm|
      content = rand_array_of_words.inject({}) do |o, w|
        o.merge(w => Faker::Hacker.noun)
      end

      dm.update_attributes(content: content)

      get(:show, id: dm.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(content))
    end
  end

  it 'should show not found when document is missing' do
    rand_array_of_uuids.each do |public_id|
      get(:show, id: public_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end
end
