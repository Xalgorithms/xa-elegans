class TransformationsController < ApplicationController
  def index
    @transformations = TransformationSerializer.many(Transformation.all)
  end
end
