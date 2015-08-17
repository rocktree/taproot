class Api::V2::SiteUsersController < Api::V2::BaseController

  def create
    begin
      p = eval(params['site_user'])
      @site = Site.find_by_uid(p[:site])
      @user = User.find_by_email(p[:user])
      @site_user = SiteUser.create!(:site => @site, :user => @user)
      response = { :site => @site.uid, :user => @user.email }
      render :json => response, :status => 200
    rescue Exception => e
      puts e.message
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

end
