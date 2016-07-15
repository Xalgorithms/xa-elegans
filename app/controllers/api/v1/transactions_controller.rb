module Api
  module V1
    class TransactionsController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_user, only: [:create, :index]
      before_filter :maybe_lookup_transactions
      before_filter :maybe_lookup_transaction, only: [:destroy]

      def create
        @transaction = Transaction.create(status: Transaction::STATUS_OPEN, user: @user)
        render(json: @transaction)
      end

      def destroy
        @transaction.update_attributes(status: Transaction::STATUS_CLOSED) if @transaction
        render(nothing: true)
      end

      def index
        if @transactions
          render(json: @transactions)
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
        @user = User.find(user_id) if user_id
      end

      def maybe_lookup_transaction
        transaction_id = params.fetch('id', nil)
        @transaction = Transaction.find(transaction_id) if transaction_id
      end
    end
  end
end
