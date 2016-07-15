module Documents
  class Change < Document
    def self.create(o)
      super(:changes, o)
    end

    def self.all
      super(:changes)
    end
    
    def initialize(doc_id)
      super(:changes, doc_id)
    end

    def key
      @doc['key']
    end

    def original
      @doc['original']
    end

    def mutated
      @doc['mutated']
    end
  end
end
