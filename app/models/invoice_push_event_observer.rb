class InvoicePushEventObserver < ActiveRecord::Observer
  def after_create(e)
    EventService.invoice_push(e)
  end
end
