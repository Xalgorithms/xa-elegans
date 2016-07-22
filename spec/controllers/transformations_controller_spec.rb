require 'rails_helper'

describe TransformationsController, type: :controller do
  describe 'GET #index' do
    it 'responds with success in all cases' do
      get(:index)

      expect(response).to be_success
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      get(:index)
      expect(response).to render_template('index')
    end

    it 'assigns all of the transformations' do
      trms = rand_array_of_models(:transformation)

      get(:index)

      expect(assigns(:transformations)).to match_array(trms)
    end
  end
end
