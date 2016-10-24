class ChangeSerializer < Serializer
  def self.serialize(chm, container=nil)
    {
      content: chm.content,
    }
  end
end
