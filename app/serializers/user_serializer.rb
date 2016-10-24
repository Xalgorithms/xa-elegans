class UserSerializer
  def self.many(ums)
    ums.map(&method(:serialize))
  end

  def self.serialize(um)
    {
      id:    um.public_id,
      email: um.email,
    }
  end
end
