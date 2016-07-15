class AccountsController < ApplicationController
  before_filter :update_accounts
  
  def index
  end

  private

  def update_accounts
    @accounts = current_user.accounts
  end
end
