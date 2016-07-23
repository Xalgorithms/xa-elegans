class DocumentSerializer
  def self.many(dms)
    docs.map(&method(:serialize))
  end

  def self.serialize(dm)
    {
      id: dm.public_id,
      url: Rails.application.routes.url_helpers.api_v1_document_path(dm.public_id),
    }
  end
end
