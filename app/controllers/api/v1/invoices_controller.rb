module Api
  module V1
    class InvoicesController < ActionController::Base
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_transaction, only: [:index]
      before_filter :maybe_lookup_user,        only: [:index]
      before_filter :maybe_lookup_invoice,     only: [:latest, :show]

      def index
        if @rel
          render(json: InvoiceSerializer.many(@rel.invoices))
        else
          render(nothing: true, status: :not_found)
        end
      end

      def latest
        if @rel && @rel.revisions.any?
          render(json: DocumentSerializer.serialize(@rel.revisions.last.document))
        else
          render(nothing: true, status: :not_found)
        end
      end

      def show
        if @rel
          render(json: InvoiceSerializer.serialize(@rel))
        else
          render(nothing: true, status: :not_found)
        end
      end
      
      private

      def maybe_lookup_invoice
        id = ['invoice_id', 'id'].inject(nil) do |v, k|
          v ||= params.fetch(k, v)
        end
        
        begin
          @rel = Invoice.find_by(public_id: id) if id
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.info("? Failed to find invoice (id=#{id})")
        end
      end

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
          @rel = User.find_by(public_id: id) if id
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.info("? Failed to find user (id=#{id})")
        end
      end
    end
  end
end
