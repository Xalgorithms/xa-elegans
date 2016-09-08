class Document < ActiveRecord::Base
  has_one :revision
  has_one :change
  has_one :invoice, through: :revision

  def initialize(*args)
    super(*args)
    self.public_id ||= UUID.generate
  end
  
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
