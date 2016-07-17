class DocumentObserver < ActiveRecord::Observer
  def after_create(dm)
    InvoiceParseService.parse(dm.id)
  end
end
