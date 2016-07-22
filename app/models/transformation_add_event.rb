class TransformationAddEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :transformation
end
