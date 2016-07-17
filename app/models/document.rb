class Document < ActiveRecord::Base
  has_one :invoice

  def currency
    content['currency']
  end

  def issued
    DateTime.parse(content['issued'])
  end
end
