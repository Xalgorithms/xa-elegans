module Api
  module V1
    class InvoicesController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_transaction, only: [:index]

      def index
        if @transaction
          render(json: InvoiceSerializer.many(@transaction.invoices))
        else
          render(nothing: true, status: :not_found)
        end
      end
      
      private

      def maybe_lookup_transaction
        id = params.fetch('transaction_id', nil)
        begin
          @transaction = Transaction.find(id) if id
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.info("? Failed to find transaction (id=#{id})")
        end
      end
    end
  end
end
