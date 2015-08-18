class Api::V2::SitesController < Api::V2::BaseController

  def index
    begin
      @sites = Site.all.collect(&:config)
      render :json => @sites, :status => 200
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

  def show
    begin
      @site = Site.find_by_uid(params[:uid])
      render :json => @site.config, :status => 200
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

  def create
    begin
      site = eval(params['site'])
      @site = Site.create!(:title => site[:title])
      render :json => @site.config, :status => 200
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

  def update
    begin
      config = eval(params['site'])
      @site = Site.find_by_uid(params[:uid])
      @site.update_config(config)
      render :json => @site.config, :status => 200
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

  # TODO: Complete the deploy process
  # def deploy
  #   begin
  #     site = eval(params['site'])
  #     uid = site[:uid]
  #     site = Site.find_by_uid(uid)
  #     system("cd #{Rails.root}/projects/#{site.slug} && git pull origin master")
  #     system("topkit generate symlinks server")
  #     config = YAML.load_file("#{Rails.root}/projects/#{site.slug}/.config")
  #     render :json => config, :status => 200
  #   rescue Exception => e
  #     render :json => { 'ERROR' => e.message }, :status => 500
  #   end
  # end

end
