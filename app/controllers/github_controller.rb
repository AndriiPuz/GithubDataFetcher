class GithubController < ApplicationController
  def search
    if params[:github_login].present?
      @user = GithubService.get_user(params[:github_login])
      @repos = GithubService.get_user_repos(params[:github_login])
    else
      flash[:alert] = 'Please enter a GitHub username'
    end
    render 'show'
  end
end
