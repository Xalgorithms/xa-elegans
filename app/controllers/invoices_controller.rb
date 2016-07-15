class InvoicesController < ApplicationController
  before_filter :maybe_find_invoice, only: [:show]
  before_filter :maybe_find_invoice_doc, only: [:show]
  
  def show
    render(layout: false)
  end

  private

  def maybe_find_invoice
    id = params.fetch('id', nil)
    @invoice = Invoice.find(id) if id
  end

  def maybe_find_invoice_doc
    if @invoice && @invoice.document_id
      @invoice_doc = Documents::Invoice.new(@invoice.document_id)
    end
  end
end
