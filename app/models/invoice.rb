require 'documents/invoice'

class Invoice < ActiveRecord::Base
  belongs_to :transact, foreign_key: :transact_id, class_name: 'Transaction'

  def document
    @document ||= Documents::Invoice.new(document_id)
  end
end
