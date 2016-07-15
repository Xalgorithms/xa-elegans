class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :status, :n_invoices

  def status
    Transaction::STATUSES[@object.status]
  end

  def n_invoices
    @object.invoices.count
  end
end
