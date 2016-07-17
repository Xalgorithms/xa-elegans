require 'rails_helper'

describe Document, type: :model do
  it 'provides currency out of the parsed content' do
    {
      'ubl/documents/UBL-Invoice-2.1-Example.xml' => 'EUR',
      'ubl/documents/icelandic-guitar/t0.xml' => 'USD',
    }.each do |fn, cur|
      
    end
  end
end
