module Api
  module V1
    class InvoicesController < ApplicationController
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token
      before_filter :maybe_lookup_account
      
      respond_to :json
      
      def create
        invoice = Invoice.create(permitted_params.merge(account: @account))
        render(json: invoice.to_json)
      end

      private

      def maybe_lookup_account
        account_id = params.fetch('account_id', nil)
        @account = Account.find(account_id) if account_id
      end

      def permitted_params
        params.require(:invoice).permit(:effective)
      end
    end
  end
end
