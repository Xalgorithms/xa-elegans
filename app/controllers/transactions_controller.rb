class TransactionsController < ApplicationController
  def index
    @transactions = TransactionSerializer.many(current_user.transactions)
  end

  def show
  end
end
