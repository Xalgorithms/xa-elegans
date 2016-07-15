class Assignment < ActiveRecord::Base
  belongs_to :invocation
  belongs_to :parameter

  def content
    JSON.parse(actual)
  end

  def name
    parameter.name
  end
end
