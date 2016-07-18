class Document < ActiveRecord::Base
  has_one :invoice

  def currency
    content['currency']
  end

  def issued
    DateTime.parse(content['issued'])
  end

  def supplier
    content['parties']['supplier']
  end

  def customer
    content['parties']['customer']
  end

  def payer
    content['parties']['payer']
  end

  def delivery
    content['delivery']
  end

  def items
    content['lines']
  end
end
