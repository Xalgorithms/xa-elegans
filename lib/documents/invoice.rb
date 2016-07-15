module Documents
  class Invoice
    def initialize(doc_id)
      cl = Mongo::Client.new(['127.0.0.1:27017'], database: 'lichen')
      @doc = cl[:invoices].find(_id: BSON::ObjectId(doc_id)).first
    end

    def id
      @doc[:id]
    end
    
    def date
      Date.parse(@doc[:issued])
    end

    def customer
      @doc[:parties][:customer][:name]
    end

    def rough_total
      @doc[:lines].map do |ln|
        Money.from_amount(ln[:price][:amount] * ln[:price][:quantity], ln[:price][:currency])
      end.inject(Money.new(0, @doc[:currency])) do |total, amt|
        total + amt
      end
    end
  end
end
