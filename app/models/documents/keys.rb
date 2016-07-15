module Documents
  module Keys
    def dotted_key_to_hash(k, v)
      do_to_hash(k.split('.'), v)
    end

    private

    def do_to_hash(ks, v)
      lv = 1 == ks.length ? v : do_to_hash(ks[1..-1], v)
      { ks.first => lv }
    end
  end
end
