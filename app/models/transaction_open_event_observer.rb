class TransactionOpenEventObserver < ActiveRecord::Observer
  def after_create(toe)
    EventService.transaction_open(toe)
  end
end
