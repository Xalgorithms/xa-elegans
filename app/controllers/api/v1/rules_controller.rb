module Api
  module V1
    class RulesController < ApplicationController
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token
      before_filter :maybe_lookup_rule
      before_filter :maybe_lookup_account

      respond_to :json

      def index
      end
      
      def create
        if @account && @rule
          Rails.logger.info("Associating (account=#{@account.id}; rule=#{@rule.id})")
          @account.rules << @rule
          render(json: @rule)
        else
          render(nothing: true, status: :not_found)
        end
      end
      
      def destroy
        if @account && @rule
          Rails.logger.info("Disassociating (account=#{@account.id}; rule=#{@rule.id})")
          @account.rules.delete(@rule)
        end
        render(nothing: true, status: :ok)
      end

      private

      def maybe_lookup_rule
        rule_id = params.fetch('id', nil)
        rule_id = params.fetch('rule', {}).fetch('id', nil) if rule_id.nil?
        @rule = Rule.find_by_id(rule_id) if rule_id
      end

      def maybe_lookup_account
        account_id = params.fetch('account_id', nil)
        @account = Account.find(account_id) if account_id
      end
    end
  end
end
