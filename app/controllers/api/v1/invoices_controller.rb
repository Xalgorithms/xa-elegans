require 'ubl/invoice'

module Api
  module V1
    class InvoicesController < ActionController::Base
      include UBL::Invoice
      
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token

      before_filter :maybe_lookup_transaction, only: [:create]
      before_filter :parse_ubl, only: [:create]

      def create
        cl = Mongo::Client.new(['127.0.0.1:27017'], database: 'lichen')
        r = cl[:invoices].insert_one(@invoice_ubl)
        @invoice = Invoice.create(transact: @transaction, document_id: r.inserted_ids.first.to_s)
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
