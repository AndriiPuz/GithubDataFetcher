require 'json'
require 'net/http'

class GithubService
  GITHUB_API_URL = ENV['GITHUB_API_URL'].freeze
  GITHUB_ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN'].freeze

  def self.get_user(login)
    query = <<~GRAPHQL
      query {
        user(login: "#{login}") {
          name
        }
      }
    GRAPHQL

    response = make_graphql_request(query)
    handle_response(response)
  end

  def self.get_user_repos(login)
    query = <<~GRAPHQL
      query {
        user(login: "#{login}") {
          repositories(first: 100) {
            nodes {
              name
              description
            }
          }
        }
      }
    GRAPHQL

    response = make_graphql_request(query)
    handle_response(response, repos: true)
  end

  private

  def self.make_graphql_request(query)
    uri = URI(GITHUB_API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    headers = {
      'Authorization' => "Bearer #{GITHUB_ACCESS_TOKEN}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }

    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = { query: }.to_json

    response = http.request(request)

    response.body if response.is_a?(Net::HTTPSuccess)
  end

  def self.handle_response(response, repos: false)
    return nil if response.blank?

    begin
      parsed_response = JSON.parse(response)
      if repos
        repo_data = parsed_response['data']['user']['repositories']['nodes']
        Rails.logger.debug { "Repositories Data: #{repo_data}" }
        repo_data.map { |data| create_repo_struct(data) }
      else
        user_data = parsed_response['data']['user']
        Rails.logger.debug { "User Data: #{user_data}" }
        create_user_struct(user_data)
      end
    rescue StandardError => e
      Rails.logger.error("Failed to handle GitHub API response: #{e.message}")
      nil
    end
  end

  def self.create_user_struct(user_data)
    Struct.new(:name).new(user_data['name'])
  end

  def self.create_repo_struct(repo_data)
    Struct.new(:name, :description).new(repo_data['name'], repo_data['description'])
  end
end
