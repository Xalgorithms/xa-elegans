require 'mongo'

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
      cl = Mongo::Client.new(['127.0.0.1:27017'], database: 'lichen')
      @invoice_doc = cl[:invoices].find(_id: BSON::ObjectId(@invoice.document_id)).first
    end
  end
end
