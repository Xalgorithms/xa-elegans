require 'rails_helper'

describe DocumentSerializer do
  it 'should serialize' do
    rand_array_of_models(:document).each do |dm|
      ex = {
        id: dm.public_id,
        url: Rails.application.routes.url_helpers.api_v1_document_path(dm.public_id),
      }
      expect(DocumentSerializer.serialize(dm)).to eql(ex)
    end
  end
end
