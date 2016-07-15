class ChangesController < ApplicationController
  before_filter :maybe_find_invoice, only: [:index]
  before_filter :maybe_find_changes, only: [:index]

  def index
    render(layout: false)
  end

  private

  def maybe_find_invoice
    invoice_id = params.fetch('invoice_id', nil)
    @invoice = Invoice.find(invoice_id) if invoice_id
  end

  def maybe_find_changes
    @changes = @invoice.applied_changes if @invoice
  end
end
