class TransformationsController < ApplicationController
  def index
    all = Transformation.all
    @transformations = TransformationSerializer.many(all)
    @in_use = all.inject({}) do |u, trm|
      u.merge(trm.public_id => Association.where(transformation: trm).count)
    end
  end
end
