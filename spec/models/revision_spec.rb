require 'rails_helper'

describe Revision, type: :model do
  include Randomness

  it 'is associated with an invoice' do
    rand_array_of_models(:invoice).each do |im|
      revm = Revision.create(invoice: im)
      expect(revm.invoice).to eql(im)
    end
  end

  it 'is associated with a document' do
    rand_array_of_models(:document).each do |dm|
      revm = Revision.create(document: dm)
      expect(revm.document).to eql(dm)
    end
  end
end
