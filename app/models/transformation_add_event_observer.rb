class TransformationAddEventObserver < ActiveRecord::Observer
  def after_create(txae)
    EventService.transformation_add(txae)
  end
end
