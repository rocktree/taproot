module ApplicationHelper

  def data
    @data ||= {
      :title => current_site ? current_site.title : SapwoodSetting.site.title
    }
  end

end
