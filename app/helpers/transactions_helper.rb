module TransactionsHelper
  def format_transaction_date(t)
    t.updated_at.to_s(:long)
  end

  def options_rules
    Rule.all.map do |rm|
      [rm.reference, rm.public_id]
    end
  end
end
