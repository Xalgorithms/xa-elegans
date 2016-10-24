class UserSerializer < Serializer
  def self.serialize(um, container=nil)
    {
      id:    um.public_id,
      email: um.email,
    }
  end
end
