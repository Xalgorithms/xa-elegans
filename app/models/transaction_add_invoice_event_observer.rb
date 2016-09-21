class TransactionAddInvoiceEventObserver < ActiveRecord::Observer
  def after_create(taie)
    EventService.transaction_add_invoice(taie)
  end
end
