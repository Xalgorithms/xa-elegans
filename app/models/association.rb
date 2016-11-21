class Association < ActiveRecord::Base
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :rule
  belongs_to :transformation

  def initialize(*args)
    super(*args)
    self.public_id ||= UUID.generate
  end
end
