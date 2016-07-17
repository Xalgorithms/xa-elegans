class Invoice < ActiveRecord::Base
  belongs_to :transact, foreign_key: :transact_id, class_name: 'Transaction'
  has_many :applied_changes, class_name: 'Change', foreign_key: 'invoice_id'
  
  def document
    @document ||= Documents::Invoice.new(document_id)
  end
end
