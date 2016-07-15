module Documents
  class Invoice
    def initialize(doc_id)
      cl = Mongo::Client.new(['127.0.0.1:27017'], database: 'lichen')
      @doc = cl[:invoices].find(_id: BSON::ObjectId(doc_id)).first
    end

    def id
      @doc['id']
    end
    
    def date
      Date.parse(@doc['issued'])
    end

    def customer
      @doc['parties']['customer']['name']
    end

    def rough_total
      @doc[:lines].map do |ln|
        pr = ln['price']
        Money.from_amount(pr['amount'] * pr['quantity'], pr['currency'])
      end.inject(Money.new(0, @doc['currency'])) do |total, amt|
        total + amt
      end
    end

    def supplier(&bl)
      party('supplier', &bl)
    end

    def customer(&bl)
      party('customer', &bl)
    end

    def payer(&bl)
      party('payer', &bl)
    end

    def delivery
      yield(@doc['delivery']) if @doc.key?('delivery')
    end
    
    def items
      @doc.fetch('lines', [])
    end

    private

    def party(k, &bl)
      all = @doc.fetch('parties', {})
      bl.call(all[k]) if bl && all.key?(k)
    end
  end
end
