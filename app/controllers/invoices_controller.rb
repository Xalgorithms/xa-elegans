class InvoicesController < ApplicationController
  before_filter :maybe_find_invoice, only: [:show]
  
  def show
    if @invoice
      doc = @invoice.documents.last
      @content = doc.content if doc
      ap @content
    end
  end

  private

  def maybe_find_invoice
    id = params.fetch('id', nil)
    @invoice = Invoice.find_by(public_id: id) if id
  end
end
