
require 'rails_helper'

describe GithubService do
  describe '.get_user' do
    it 'fetches user data from GitHub API', :vcr do
      user_data = GithubService.get_user('dhh')
      expect(user_data).not_to be_nil
    end
  end

  describe '.get_user_repos' do
    it 'fetches user repositories from GitHub API', :vcr do
      repos_data = GithubService.get_user_repos('dhh')
      expect(repos_data).not_to be_nil
    end
  end
end
