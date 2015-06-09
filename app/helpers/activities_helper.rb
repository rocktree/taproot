module ActivitiesHelper

  def render_activities(name, partial = nil)
    if partial.nil?
      render send("#{name}_activities")
    else
      render :partial => partial, :collection => send("#{name}_activities")
    end
  end

  def app_activities
    @activities = Activity.order('created_at desc')
      .where('user_id IS NOT ?', nil).includes(:item, :site, :user)
      .limit(40).reject { |a| a.item.blank? }.first(20)
  end

  def site_base_activities
    Activity.order('created_at desc')
            .where('site_id = ? AND user_id IS NOT ?', current_site.id, nil)
  end

  def site_activities
    @activities = site_base_activities
      .includes(:item, :site, :user).limit(40).reject { |a| a.item.blank? }.first(20)
      .sort_by(&:created_at).reverse
  end

  def users_activities
    @activities = Activity.where(:user_id => all_site_users.collect(&:id))
      .where(:item_type => 'User')
      .includes(:item, :user).limit(40).reject { |a| a.item.blank? }
      .first(20).sort_by(&:created_at).reverse
  end

  def custom_settings_activities
    @activities = site_base_activities
      .where(:item_type => 'SiteSetting')
      .includes(:item, :site, :user).limit(40).reject { |a| a.item.blank? }
      .first(20).sort_by(&:created_at).reverse
  end

  def activity_path(activity)
    if activity.item_type == 'User'
      builder_route([activity.item], :show)
    else
      activity.item_path
    end
  end

  def activity_content(activity)
    o  = content_tag(:span, "#{activity.user.display_name}", :class => 'user')
    o += " #{activity.action} #{activity.item_type.underscore.humanize.downcase} "
    o += link_to("#{activity.item.title}", activity_path(activity), :class => 'item')
  end

end
