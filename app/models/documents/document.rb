module Documents
  class Document
    def self.create(collection, json)
      cl = Mongo::Client.new(ENV['MONGOLAB_URI'])
      r = cl[collection].insert_one(json)
      r.inserted_ids.first.to_s
    end

    def self.destroy_all(collection)
      cl = Mongo::Client.new(ENV['MONGOLAB_URI'])
      r = cl[collection].delete_many
      r.n
    end
    
    def self.all(collection)
      cl = Mongo::Client.new(ENV['MONGOLAB_URI'])
      cl[collection].find.to_a
    end
    
    def initialize(collection, doc_id)
      cl = Mongo::Client.new(ENV['MONGOLAB_URI'])
      @doc = cl[collection].find(_id: BSON::ObjectId(doc_id)).first
    end
  end
end
