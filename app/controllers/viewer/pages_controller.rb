class Viewer::PagesController < ViewerController

  before_filter :cors_check

  def home
    @current_page = current_site.home_page
    if @current_page.nil? || (@current_page.draft? && Rails.env.production?)
      not_found
    else
      show
    end
  end

  def show
    if @current_page.nil?
      slug = params[:page_path].split('/').last
      @current_page = current_site.pages.find_by_slug(slug)
    end
    not_found if current_page.nil?
    resolve_layout
    render(
      "viewer/#{current_site.slug}/#{current_page_template}", 
      :layout => @layout
    )
  end

  private

    def resolve_layout
      if params[:layout] && params[:layout].to_bool == false
        @layout = false
      else
        @layout = "viewer/#{current_site.slug}"
      end
    end

    def cors_check
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

end
