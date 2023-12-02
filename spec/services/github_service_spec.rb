require 'rails_helper'

describe GithubService, type: :service do
  describe '.get_user' do
    it 'fetches user data from GitHub API', :vcr do
      VCR.use_cassette('github_service_get_user') do
        user = described_class.get_user('dhh')
        expect(user).to be_a(Struct)
        expect(user.name).to eq('David Heinemeier Hansson')
      end
    end
  end

  describe '.get_user_repos' do
    it 'fetches user repositories from GitHub API', :vcr do
      VCR.use_cassette('github_service_get_user_repos') do
        repos = described_class.get_user_repos('dhh')
        expect(repos).to be_an(Array)
        expect(repos.first).to be_a(Struct)
        expect(repos.first.name).to eq('conductor')
        expect(repos.first.description).to be_nil
      end
    end
  end

  describe '.make_graphql_request' do
    it 'sends a GraphQL request to GitHub API', :vcr do
      VCR.use_cassette('github_service_make_graphql_request') do
        query = <<~GRAPHQL
          query {
            user(login: "example_user") {
              name
            }
          }
        GRAPHQL

        response = described_class.send(:make_graphql_request, query)
        expect(response).to be_a(String)
      end
    end
  end

  describe '.handle_response' do
    it 'handles a successful GitHub API response' do
      response = '{"data":{"user":{"name":"David Heinemeier Hansson"}}}'
      user = described_class.send(:handle_response, response)
      expect(user).to be_a(Struct)
      expect(user.name).to eq('David Heinemeier Hansson')
    end

    it 'handles a successful GitHub API response for repositories' do
      response = '{"data":{"user":{"repositories":{"nodes":[{"name":"Repo","description":"Description"}]}}}}'
      repos = described_class.send(:handle_response, response, repos: true)
      expect(repos).to be_an(Array)
      expect(repos.first).to be_a(Struct)
      expect(repos.first.name).to eq('Repo')
      expect(repos.first.description).to eq('Description')
    end

    it 'handles a failed GitHub API response' do
      response = '{"errors":[{"message":"Error message"}]}'
      result = described_class.send(:handle_response, response)
      expect(result).to be_nil
    end
  end
end
