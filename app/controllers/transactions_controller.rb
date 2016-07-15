class TransactionsController < ApplicationController
  before_filter :find_transactions, only: [:index]
  
  def index
  end

  def show
  end

  private

  def find_transactions
    @transactions = current_user.transactions
  end
end
