class TransactionCloseEventObserver < ActiveRecord::Observer
  def after_create(tce)
    EventService.transaction_close(tce)
  end
end
