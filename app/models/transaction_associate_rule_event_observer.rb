class TransactionAssociateRuleEventObserver < ActiveRecord::Observer
  def after_create(tare)
    EventService.transaction_associate_rule(tare)
  end
end
