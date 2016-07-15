module Api
  module V1
    class AccountsController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_account, only: [:show]

      def show
        render(json: @account)
      end
      
      private
      
      def maybe_lookup_account
        id = params.fetch('id', nil)
        @account = Account.find(id) if id
      end
    end
  end
end
