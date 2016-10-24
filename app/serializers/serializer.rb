class Serializer
  def self.many(models, container = nil)
    models.map { |m| serialize(m, container) }
  end
end
