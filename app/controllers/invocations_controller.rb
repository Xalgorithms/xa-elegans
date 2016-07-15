class InvocationsController < ApplicationController
  before_filter :maybe_lookup_account, only: [:new, :show]
  before_filter :maybe_lookup_invocation, only: [:edit, :show]

  def new
    @invocation = Invocation.new(account: @account)
    render(layout: false)
  end

  def edit
    render(layout: false)
  end

  def show
    render(layout: false)
  end
  
  private

  def maybe_lookup_account
    id = params.fetch('account_id', nil)
    @account = Account.find(id) if id
  end

  def maybe_lookup_invocation
    invocation_id = params.fetch('id', nil)
    @invocation = Invocation.find(invocation_id) if invocation_id
  end
end
