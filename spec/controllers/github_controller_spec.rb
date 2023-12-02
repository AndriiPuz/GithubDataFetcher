require 'rails_helper'

describe GithubController do
  describe 'GET #search' do
    context 'with valid GitHub username' do
      it 'fetches user and repositories data from GitHub API', :vcr do
        get :search, params: { github_login: 'dhh' }
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:repos)).not_to be_nil
        expect(response).to render_template('search')
      end
    end

    context 'with missing GitHub username' do
      it 'handles missing GitHub username', :vcr do
        get :search, params: { github_login: '' }
        expect(flash[:alert]).to eq('Please enter a GitHub username')
        expect(response).to render_template('search')
      end
    end

    context 'with mocked GitHubService data' do
      before do
        allow(GithubService).to receive_messages(get_user: Struct.new(:name).new('Andrii Puzyr'), get_user_repos: [Struct.new(:name, :description).new('Repo', 'Description')])
      end

      it 'assigns user and repos' do
        get :search, params: { github_login: 'example_user' }
        expect(assigns(:user).name).to eq('Andrii Puzyr')
        expect(assigns(:repos).first.name).to eq('Repo')
        expect(assigns(:repos).first.description).to eq('Description')
      end

      it 'renders the search template' do
        get :search
        expect(response).to render_template('search')
      end

      it 'sets flash alert when github_login is not present' do
        get :search, params: { github_login: '' }
        expect(flash.now[:alert]).to eq(I18n.t('github.please_enter_username'))
      end
    end
  end
end
