class ApiConstraint
  attr_reader :version
  
  def initialize(opts)
    # TODO: configure latest constant
    @version = opts.fetch(:version, 1)
  end

  def matches?(req)
    req.headers.fetch(:accept, {}).include?("version=#{version}")
  end
end
