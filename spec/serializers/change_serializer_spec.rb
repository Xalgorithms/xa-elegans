require 'rails_helper'

describe ChangeSerializer do
  it 'should serialize' do
    rand_array_of_models(:change).each do |chm|
      content = rand_array_of_words.inject({}) do |o, w|
        o.merge(w => Faker::Number.number(4))
      end
      chm.update_attributes(content: content)
      
      ex = {
        content: content
      }
      expect(ChangeSerializer.serialize(chm)).to eql(ex)
    end
  end
end
