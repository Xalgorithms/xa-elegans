class Assignment < ActiveRecord::Base
  belongs_to :invocation
  belongs_to :parameter
end
