require 'rails_helper'

require 'xa/transforms/parse'

describe ParseService do
  include XA::Transforms::Parse

  it 'should parse transformations' do
    rand_array_of_models(:transformation).each do |txm|
      src = 'ADAPTS foo'
      ex = parse([src])
      
      txm.update_attributes(src: src)
      ParseService.parse_transformation(txm.id)

      expect(Transformation.find(txm.id).content).to eql(ex)
    end
  end
end
