class Api::V2::BaseController < ActionController::Base

  before_filter :ensure_json_request
  before_filter :authenticate

  def missing
    head :unauthorized
  end

  private

    def ensure_json_request
      return if params[:format] == "json" || request.headers["Accept"] =~ /json/
      render :nothing => true, :status => 406
    end

    def authenticate
      api_key = request.headers['X-Api-Key']
      @user = User.find_by_api_key(api_key) if api_key
      head :unauthorized if @user.nil?
    end

end
