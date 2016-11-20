class Transformation < ActiveRecord::Base
  def initialize(*args)
    super(*args)
    self.public_id ||= UUID.generate
  end
end
