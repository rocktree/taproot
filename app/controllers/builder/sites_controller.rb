class Builder::SitesController < BuilderController

  before_filter :set_layout_options

  def index
  end

  def show
    redirect_to builder_site_pages_path(current_site)
  end

  def new
    @current_site = Site.new
  end

  def create
    @current_site = Site.new(create_params)
    if current_site.save
      if params[:site][:new_repo].to_bool
        create_sapwood_project
      end
      redirect_to(
        route([current_site], :edit, 'builder'), 
        :notice => t('notices.created', :item => "Site")
      ) 
    else
      render('new')
    end
  end

  def edit
    current_site = current_site
  end

  def update
    if current_site.update(update_params)
      redirect_to(route([current_site], :edit, 'builder'), 
        :notice => t('notices.updated', :item => "Site")) 
    else
      render('edit')
    end
  end

  def destroy
    sapwood = SapwoodProject.new(current_site)
    sapwood.remove_files
    current_site.destroy
    redirect_to(builder_sites_path, :notice => 'Site deleted successfully.')
  end

  def pull
    if current_site
      UpdateProjectWorker.perform_async(current_site.id)
    end
    redirect_to(
      route([current_site], :edit, 'builder'), 
      :notice => 'Working on the task behind the scenes.'
    ) 
  end

  def import
    sapwood = SapwoodProject.new(current_site)
    sapwood.import_site
    redirect_to(
      route([current_site], :edit, 'builder'), 
      :notice => 'Repo imported successfully!'
    ) 
  end

  def backup
    SapwoodDatabase.new.backup
    redirect_to(
      route([current_site], :edit, 'builder'), 
      :notice => 'Database backed up successfully!'
    )
  end

  def sync
    remote_url = SapwoodSetting.remote.url
    key = SapwoodSetting.api.public_key
    system("curl http://#{remote_url}/api/v1/database/dump?public_key=#{key}")
    SapwoodDatabase.new.sync
    redirect_to(
      route([current_site], :edit, 'builder'), 
      :notice => 'Database synced successfully!'
    )
  end

  def symlink
    SapwoodProject.new(current_site).update_symlinks
    redirect_to(
      route([current_site], :edit, 'builder'), 
      :notice => 'Symlinked successfully!'
    ) 
  end

  private

    def create_params
      params.require(:site).permit(
        :title, 
        :url, 
        :secondary_urls,
        :description,
        :home_page_id,
        :git_url,
        :image_croppings_attributes => [
          :id, 
          :title,
          :ratio,
          :width,
          :height
        ]
      )
    end

    def update_params
      create_params
    end

    def set_layout_options
      if ['index', 'new', 'create'].include?(action_name)
        @options['sidebar'] = false
        @options['body_classes'] += ' my-sites'
      end
    end

    def create_sapwood_project
      sapwood = SapwoodProject.new(current_site)
      sapwood.create_site
    end

end
