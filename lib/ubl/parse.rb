module UBL
  module Parse
    def load_and_parse(urn, sym_root_xp, sym_make, &bl)
      load(urn) do |doc|
        maybe_find_one(doc, send(sym_root_xp, doc)) do |n|
          rv = send(sym_make, n)
          bl.call(rv) if rv && rv.any? && bl
        end
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
