class TransactionExecuteEventObserver < ActiveRecord::Observer
  def after_create(tce)
    EventService.transaction_execute(tce)
  end
end
