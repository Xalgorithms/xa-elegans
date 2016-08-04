class TransformationDestroyEventObserver < ActiveRecord::Observer
  def after_create(txde)
    EventService.transformation_destroy(txde)
  end
end
