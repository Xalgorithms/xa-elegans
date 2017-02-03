module InvoicesHelper
  def visible_totals
    {
      total: 'Subtotal',
      tax_exclusive: 'Tax',
      payable: 'Total',
    }
  end
  
  def format_quantity(quantity, code)
    "#{quantity} (#{code})"
  end
  
  def make_money(amount, currency)
    c = Money::Currency.new(currency)
    Money.new(amount.to_i * c.subunit_to_unit, c)
  end
  
  def format_price(amount, currency)
    m = make_money(amount, currency)
    "#{m.format()} (#{m.currency.iso_code})"
  end

  def format_rate(pricing)
    pr = format_price(pricing['price']['value'], pricing['price']['currency'])
    qu = format_quantity(pricing['quantity']['value'], pricing['quantity']['code'])
    "#{pr} / #{qu}"
  end
end
