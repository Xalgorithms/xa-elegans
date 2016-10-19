class TransactionBindSourceEventObserver < ActiveRecord::Observer
  def after_create(e)
    EventService.transaction_bind_source(e)
  end
end
