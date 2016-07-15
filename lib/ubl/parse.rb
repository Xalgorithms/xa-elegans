module UBL
  module Parse
    def parse(urn)
      load(urn) do |doc|
        invoice = {}.tap do |o|
          maybe_find_one(doc, "#{ns(doc, :invoice)}:Invoice") do |invoice_el|
            maybe_find_one_text(invoice_el, "#{ns(doc, :cbc)}:ID") do |text|
              o[:id] = text
            end
            maybe_find_one_text(invoice_el, "#{ns(doc, :cbc)}:IssueDate") do |text|
              o[:issued] = text
            end
            maybe_find_one_text(invoice_el, "#{ns(doc, :cbc)}:DocumentCurrencyCode") do |text|
              o[:currency] = text
            end
            
            maybe_find_period(invoice_el) do |period|
              o[:period] = period
            end
            
            maybe_find_parties(invoice_el) do |parties|
              o[:parties] = parties
            end
          end
        end
        
        yield(invoice)
      end
    end

    def load(urn)
      doc = Nokogiri::XML(open(urn)) do |cfg|
        cfg.noblanks.noent
      end
      yield(doc) if doc
    end
    
    def ns(n, k)
      if !@nses
        @namespace_urns ||= {
          invoice: 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
          cac:     'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
          cbc:     'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
        }
        doc_nses = n.document.namespaces.invert
        @nses = @namespace_urns.keys.inject({}) do |o, k|
          o.merge(k => doc_nses[@namespace_urns[k]].split(':').last)
        end
      end
      
      @nses[k]
    end
  end
end
