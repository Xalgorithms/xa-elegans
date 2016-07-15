module InvoiceHelper
  def format_address(address)
    if address
      fmt = '{{street}}\n{{postalcode}} {{city}}\n{{country}}'
      # countries templates are not great, needs improvement
      country = ISO3166::Country.new(address.fetch('country_code', nil))
      if country
        fmt = country.address_format if country.address_format
        tmpl = Liquid::Template.parse(fmt)
        lines = tmpl.render(
          'street' => "#{address.fetch('number', '')} #{address.fetch('street', {}).fetch('name', '')}",
          'region' => address.fetch('region', nil),
          'postalcode' => address.fetch('zone', nil),
          'city' => address.fetch('city', nil),
          'country' => country.name,
        )
        yield(lines.split(/\n/).reject(&:empty?))
      end
    end
  end

  def format_item_price(it)
    Money.from_amount(it['amount'], it['currency']).format
  end
end
