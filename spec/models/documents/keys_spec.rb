require 'xa/hash/deep'

describe Documents::Keys do
  include Documents::Keys
  
  it 'converts a flattened key to a nested hash' do
    rand_times.each do
      k = rand_array_of_words.join('.')
      v = Faker::Lorem.word
      h = dotted_key_to_hash(k, v)

      expect(h).to_not be_nil
      expect(h.deep_fetch(k)).to eql(v)
    end
  end
end
