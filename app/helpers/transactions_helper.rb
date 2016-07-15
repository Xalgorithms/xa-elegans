require 'documents/invoice'

module TransactionsHelper
  def format_transaction_date(t)
    t.updated_at.to_s(:long)
  end

  def transaction_status_as_label(t)
    @status_labels ||= {
      Transaction::STATUS_OPEN   => '.status.open',
      Transaction::STATUS_CLOSED => '.status.closed',
    }
    @status_labels.fetch(t.status, '.status.unknown')
  end

  def transaction_invoice_docs(t)
    t.invoices.map { |inv| [inv, Documents::Invoice.new(inv.document_id)] }
  end
end
