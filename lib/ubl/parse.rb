module UBL
  module Parse
    def load_and_parse_urn(urn, sym_root_xp, sym_make, &bl)
      load_and_parse(open(urn), sym_root_xp, sym_make, &bl)
    end

    def load_and_parse(b, sym_root_xp, sym_make, &bl)
      load(b) do |doc|
        maybe_find_one(doc, send(sym_root_xp, doc)) do |n|
          rv = send(sym_make, n)
          bl.call(rv) if rv && rv.any? && bl
        end
      end
    end

    def load(b)
      doc = Nokogiri::XML(b) do |cfg|
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
        nses = n.namespaces.invert
        @nses = @namespace_urns.keys.inject({}) do |o, k|
          o.merge(k => nses[@namespace_urns[k]].split(':').last)
        end
      end
      
      @nses[k]
    end
  end
end
