module Documents
  class Invoice < Document
    def self.create(json)
      super(:invoices, json.merge(version: 1))
    end

    def self.all
      super(:invoices)
    end
    
    def self.destroy_all
      super(:invoices)
    end
    
    def initialize(doc_id)
      super(:invoices, doc_id)
    end

    def id
      @doc['id']
    end

    def content
      @doc
    end

    def currency
      @doc['currency']
    end
    
    def date
      Date.parse(@doc['issued'])
    end

    def deep_fetch(k)
      @doc.deep_fetch(k)
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
