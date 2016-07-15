require 'ubl/invoice'

require 'mongo'

module Api
  module V1
    class InvoicesController < ActionController::Base
      include UBL::Invoice
      
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_transaction, only: [:create, :index]
      before_filter :parse_ubl, only: [:create]

      def index
        if @transaction
          render(json: @transaction.invoices)
        else
          render(nothing: true, status: :not_found)
        end
      end
      
      def create
        doc_id = Documents::Invoice.create(@invoice_ubl)
        @invoice = Invoice.create(transact: @transaction, document_id: doc_id)
        render(json: @invoice)
      end

      private

      def parse_ubl
        parse(request.raw_post) do |invoice|
          @invoice_ubl = invoice
        end
      end
      
      def maybe_lookup_transaction
        id = params.fetch('transaction_id', nil)
        @transaction = Transaction.find(id) if id
      end
    end
  end
end
