class RegisterEventObserver < ActiveRecord::Observer
  def after_create(re)
    EventService.register(re)
  end
end
