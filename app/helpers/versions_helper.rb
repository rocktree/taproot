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
      .where('whodunnit IS NOT ?', nil).includes(:item => [:reference_cache])
      .limit(20)

    @version_users = User.where(:id => @versions.collect(&:whodunnit))
    @versions
  end

  def version_user(v)
    @version_users.select { |u| u.id == v.whodunnit.to_i }.first
  end

  def version_content(v)
    o  = content_tag(:span, "#{version_user(v).display_name}", :class => 'user')
    o += " #{v.event}d #{v.item_type.underscore.humanize.downcase} "
    o += link_to("#{v.item.title}", v.item.cache.item_path, :class => 'item')
  end

end
