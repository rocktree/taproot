module SitesHelper

  def current_site
    @current_site ||= begin
      if(
        ['localhost',SapwoodSetting.site.url].include?(request.host) ||
        request.host =~ /^192\.168/ || request.host =~ /^10\.1/
      )
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
      admin? ? Site.alpha : current_user.sites.alpha
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

  def builder_html_title
    @builder_html_title ||= SapwoodSetting.site.title
  end

  def my_sites_breadcrumbs
    o = link_to("my sites", builder_sites_path)
    if current_site
      o += content_tag(:span, '/', :class => 'separator')
      if current_site.title.blank?
        o += link_to(
          "new site",
          new_builder_site_path
        )
      else
        o += link_to(
          my_sites.slug,
          edit_builder_site_path(current_site)
        )
      end
    end
    o.html_safe
  end

  def current_site_breadcrumbs
    @current_site_breadcrumbs ||= begin
      o = link_to("site settings", edit_builder_site_path(current_site))
    end
  end

  def current_site_actions
    s = current_site
    actions = [
      {
        :title => "Site Details",
        :path => edit_builder_site_path(s),
        :class => 'edit'
      },
      {
        :title => "Custom Settings",
        :path => builder_site_site_settings_path(s),
        :class => 'settings',
        :controllers => ['settings']
      },
      {
        :title => "Image Croppers",
        :path => builder_site_cropper_path(s),
        :class => 'crop'
      },
      # {
      #   :title => 'Deploy Code',
      #   :path => builder_site_pull_path(current_site),
      #   :class => 'download',
      #   :request_type => 'post',
      #   :confirm => 'Are you sure? This will stash any changes you have made.'
      # },
      # {
      #   :title => 'Import New Repo',
      #   :path => builder_site_import_path(current_site),
      #   :class => 'code',
      #   :request_type => 'post',
      #   :confirm => 'Ready to import project?'
      # },
      # {
      #   :title => 'Generate Symlinks',
      #   :path => builder_site_symlink_path(current_site),
      #   :class => 'link',
      #   :request_type => 'post'
      # }
    ]
    # if Rails.env.production?
    #   actions << {
    #     :title => 'Backup Database',
    #     :path => builder_site_backup_path(current_site),
    #     :class => 'database',
    #     :request_type => 'post'
    #   }
    # end
    actions
  end

  def setting_last_updated(setting)
    date = setting.updated_at.strftime("%h %d")
    content_tag(:span, :class => 'last-edited') do
      "Last updated #{content_tag(:span, date)}".html_safe
    end
  end

end
