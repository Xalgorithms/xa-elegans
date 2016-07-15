module Api
  module V1
    class AccountsController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_user, only: [:index]
      before_filter :maybe_lookup_account, only: [:show]

      def index
        render(json: Account.all)
      end
      
      def show
        render(json: @account)
      end
      
      private
      
      def maybe_lookup_user
        user_id = params.fetch('user_id', nil)
        @user = User.find(user_id) if user_id
      end

      def maybe_lookup_account
        id = params.fetch('id', nil)
        @account = Account.find(id) if id
      end
    end
  end
end
