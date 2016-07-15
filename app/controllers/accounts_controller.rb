class AccountsController < ApplicationController
  before_filter :find_accounts
  
  def index
  end

  private

  def find_accounts
    @accounts = current_user.accounts
  end
end
