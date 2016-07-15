class RulesController < ApplicationController
  respond_to :json

  before_filter :lookup_rule
  before_filter :maybe_lookup_account
  
  def destroy
    if @account
      Rails.logger.info("Disassociating (account=#{@account.id}; rule=#{@rule.id})")
      @account.rules.delete(@rule)
    end
    render(nothing: true, status: :ok)
  end

  private

  def lookup_rule
    @rule = Rule.find(params['id'])
  end

  def maybe_lookup_account
    params.fetch('account_id', nil)
    @account = Account.find(account_id) if account_id
  end
end
