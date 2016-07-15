module Api
  module V1
    class InvoicesController < ApplicationController
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token
      before_filter :maybe_lookup_account
      before_filter :maybe_lookup_invoice, only: [:destroy]
      
      respond_to :json
      
      def create
        invoice = Invoice.create(permitted_params.merge(account: @account))
        render(json: invoice.to_json)
      end

      def destroy
        if @invoice
          Rails.logger.info("Destroying invoice (id=#{@invoice.id})")
          @invoice.destroy
          render(nothing: true, status: :ok)
        else
          Rails.logger.warn('Failed to locate invoice to destroy')
          render(nothing: true, status: :not_found)
        end
      end
      
      private

      def maybe_lookup_account
        account_id = params.fetch('account_id', nil)
        @account = Account.find(account_id) if account_id
      end

      def maybe_lookup_invoice
        invoice_id = params.fetch('id', nil)
        @invoice = Invoice.find(invoice_id) if invoice_id
      end
      
      def permitted_params
        params.require(:invoice).permit(:effective)
      end
    end
  end
end
