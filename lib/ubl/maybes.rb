module UBL
  module Maybes
    def maybe_find_one(pn, xp, &bl)
      rv = pn.xpath(xp).first
      rv = bl.call(rv) if rv && bl
      rv
    end

    def maybe_find_set(pn, xp_set, &bl)
      rv = xp_set.keys.inject({}) do |o, k|
        maybe_find_one(pn, xp_set[k]) do |n|
          o = o.merge(k => n)
        end

        o
      end
      rv = bl.call(rv) if rv.any? && bl
      rv
    end

    def maybe_find_set_text(pn, xp_set, &bl)
      rv = {}
      maybe_find_set(pn, xp_set) do |s|
        rv = s.inject({}) do |o, kv|
          o.merge(kv.first => kv.last.text)
        end
      end

      rv = bl.call(rv) if rv.any? && bl
      rv
    end
    
    def maybe_find_one_text(pn, xp, &bl)
      maybe_find_one(pn, xp) do |n|
        rv = n.text
        rv = bl.call(rv) if bl
        rv
      end
    end
    
    def maybe_find_one_convert(sym, pn, xp, &bl)
      maybe_find_one(pn, xp) do |n|
        rv = send(sym, n)
        rv = bl.call(rv) if rv && rv.any? && bl
        rv
      end
    end
  end
end
