module SitesHelper

  def current_site
    @current_site ||= begin
      if ['localhost',SapwoodSetting.site.url].include?(request.host)
        p = params[:site_slug] || params[:slug]
        if user_signed_in?
          my_sites.select{ |s| s.slug == p }.first unless p.nil?
        else
          Site.find_by_slug(p) unless p.nil?
        end
      else
        Site.find_by_url(request.host)
      end
    end
  end

  def my_sites
    @my_sites ||= begin
      admin? ? Site.last_updated : current_user.sites.last_updated
    end
  end

  def has_sites?
    my_sites.size > 0
  end

  def has_multiple_sites?
    my_sites.size > 1
  end

  def only_site
    my_sites.first unless has_multiple_sites?
  end

end
