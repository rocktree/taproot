class Api::V2::SitesController < Api::V2::BaseController

  def create
    begin
      site = eval(params['site'])
      git_url = site[:git_url]
      system("rm -rf .topkit-import")
      system("git clone #{git_url} .topkit-import")
      config = YAML.load_file("#{Rails.root}/.topkit-import/.config")
      system("mv .topkit-import projects/#{config['slug']}")
      system("topkit generate symlinks server")
      @site = Site.create!(
        :title => config['title'],
        :uid => config['uid'],
        :git_url => git_url
      )
      @site.update_config!
      render :json => config, :status => 200
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

  def deploy
    begin
      site = eval(params['site'])
      uid = site[:uid]
      site = Site.find_by_uid(uid)
      system("cd #{Rails.root}/projects/#{site.slug} && git pull origin master")
      system("topkit generate symlinks server")
      site.update_config!
      config = YAML.load_file("#{Rails.root}/projects/#{site.slug}/.config")
      render :json => config, :status => 200
    rescue Exception => e
      puts e.message
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

end
