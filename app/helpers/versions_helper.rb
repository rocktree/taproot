module VersionsHelper

  def render_versions(name, partial = nil)
    if partial.nil?
      render send("#{name}_versions")
    else
      render :partial => partial, :collection => send("#{name}_versions")
    end
  end

  def app_versions
    @versions = PaperTrail::Version.order('created_at desc')
      .where('whodunnit IS NOT ?', nil).limit(20)

    @version_users = User.where(:id => @versions.collect(&:whodunnit))
    @versions
  end

  def version_user(v)
    @version_users.select { |u| u.id == v.whodunnit.to_i }.first
  end

  def version_path(v)
    case v.item_type
    when 'Site'
      builder_site_path(v.item)
    when 'Page', 'Form'
      send(
        "builder_site_#{v.item_type.downcase.underscore}_path",
        version_site(v), v.item
      )
    when 'FormField'
      builder_site_form_form_fields_path(v.item.site, v.item.form)
    end
  end

  def version_content(v)
    o  = content_tag(:span, "#{version_user(v).display_name}", :class => 'user')
    o += " #{v.event}d #{v.item_type.underscore.humanize.downcase} "
    o += link_to("#{v.item.title}", version_path(v), :class => 'item')
  end

  def version_site(v)
    v.item.site
  end

  def version_site_link(v)
    case v.item_type
    when 'Site'
      link_to(v.item.title, builder_site_path(v.item))
    else
      link_to(version_site(v).title, builder_site_path(v.item.site))
    end
  end

end
