class DocumentSerializer < Serializer
  def self.serialize(dm, container=nil)
    {
      id: dm.public_id,
      url: Rails.application.routes.url_helpers.api_v1_document_path(dm.public_id),
    }
  end
end
