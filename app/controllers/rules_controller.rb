class RulesController < ApplicationController
  respond_to :json
  
  def destroy
    render(nothing: true, status: :ok)
  end
end
