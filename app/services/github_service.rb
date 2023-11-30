class GithubService
  GITHUB_API_URL = 'https://api.github.com'.freeze

  def self.get_user(login)
    url = "#{GITHUB_API_URL}/users/#{login}"
    response = make_request(url)
    handle_response(response)
  end

  def self.get_user_repos(login)
    url = "#{GITHUB_API_URL}/users/#{login}/repos"
    response = make_request(url)
    handle_response(response)
  end

  private

  def self.make_request(url)
    response = HTTParty.get(url)
    response.body if response.success?
  end

  def self.handle_response(response)
    return nil unless response.present?

    begin
      parsed_response = JSON.parse(response)
      if parsed_response.is_a?(Array)
        parsed_response.map { |repo_data| create_repo_openstruct(repo_data) }
      else
        create_repo_openstruct(parsed_response)
      end
    rescue StandardError => e
      Rails.logger.error("Failed to handle GitHub API response: #{e.message}")
      nil
    end
  end

  def self.create_repo_openstruct(repo_data)
    OpenStruct.new(
      name: repo_data['name'],
      description: repo_data['description']
    )
  end
end
