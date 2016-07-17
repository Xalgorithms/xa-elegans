module Api
  module V1
    class TransactionsController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_user, only: [:index]
      before_filter :maybe_lookup_transactions, only: [:index]

      def index
        if @transactions
          render(json: TransactionSerializer.many(@transactions))
        else
          render(nothing: true, status: :not_found)
        end
      end

      private

      def maybe_lookup_transactions
        if @user
          @transactions = @user.transactions
        end
      end
      
      def maybe_lookup_user
        user_id = params.fetch('user_id', nil)
        begin
          @user = User.find(user_id) if user_id
        rescue
          Rails.logger.warn("! Failed lookup (user_id=#{user_id})")
        end
      end
    end
  end
end
