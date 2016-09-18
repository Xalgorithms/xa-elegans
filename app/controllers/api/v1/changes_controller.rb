require 'xa/util/documents'

module Api
  module V1
    class ChangesController < ActionController::Base
      include XA::Util::Documents
      
      # TODO: do this properly
      skip_before_filter  :verify_authenticity_token
      
      before_filter :maybe_lookup_invoice,  only: [:show]

      def show
        content = nil
        if @invoice
          latest = @invoice.revisions[-1]
          previous = @invoice.revisions[-2]
          content = {}.tap do |o|
            if latest && latest.document && latest.document.change
              o[:latest] = latest.document.change.content
              o[:previous] = extract_corresponding(previous.document.content, latest.document.change.content) if previous && previous.document && previous.document.content
            end
          end
        end

        if content && content.any?
          render(json: content)
        else
          render(nothing: true, status: :not_found)
        end
      end

      private

      def maybe_lookup_invoice
        id = params.fetch('invoice_id', nil)
        @invoice = Invoice.find_by(public_id: id) if id
      end
    end
  end
end
