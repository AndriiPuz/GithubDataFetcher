
require 'rails_helper'

describe GithubController, type: :controller do
  describe 'GET #search' do
    it 'fetches user and repositories data from GitHub API', :vcr do
      get :search, params: { github_login: 'dhh' }
      expect(assigns(:user)).not_to be_nil
      expect(assigns(:repos)).not_to be_nil
      expect(response).to render_template('show')
    end

    it 'handles missing GitHub username', :vcr do
      get :search, params: { github_login: '' }
      expect(flash[:alert]).to eq('Please enter a GitHub username')
      expect(response).to render_template('show')
    end
  end
end
