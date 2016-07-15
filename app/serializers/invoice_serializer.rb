class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :document

  def document
    @object.document.content
  end
end
