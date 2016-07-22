class TransformationsController < ApplicationController
  def index
    @transformations = Transformation.all
  end
end
