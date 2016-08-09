module Api
  module V1
    class InvoicesController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_transaction, only: [:index]
      before_filter :maybe_lookup_user,        only: [:index]

      def index
        if @rel
          render(json: InvoiceSerializer.many(@rel.invoices))
        else
          render(nothing: true, status: :not_found)
        end
      end
      
      private

      def maybe_lookup_transaction
        id = params.fetch('transaction_id', nil)
        begin
          @rel = Transaction.find_by(public_id: id) if id
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.info("? Failed to find transaction (id=#{id})")
        end
      end

      def maybe_lookup_user
        id = params.fetch('user_id', nil)
        begin
          @rel = User.find(id) if id
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.info("? Failed to find user (id=#{id})")
        end
      end
    end
  end
end
