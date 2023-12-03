class GithubController < ApplicationController
  def search
    if params[:github_login].present?
      @user = GithubService.get_user(params[:github_login])
      @repos = Kaminari.paginate_array(GithubService.get_user_repos(params[:github_login])).page(params[:page]).per(10)
    else
      flash.now[:alert] = I18n.t('github.please_enter_username')
    end
    render 'search'
  end
end
