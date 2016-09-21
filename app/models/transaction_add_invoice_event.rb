class TransactionAddInvoiceEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :document
  belongs_to :invoice
end
