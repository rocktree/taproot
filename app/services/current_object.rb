class CurrentObject

  def initialize(request, params)
    @request = request
    @params = params
  end

  def site
    @site ||= begin
      if params[:site_uid]
        Site.find_by_uid(params[:site_uid])
      else
        nil
      end
    end
    # @current_site ||= begin
    #   if(
    #     ['localhost',TopkitSetting.site.url].include?(request.host) ||
    #     request.host =~ /^192\.168/ || request.host =~ /^10\.1/
    #   )
    #     p = params[:site_slug] || params[:slug]
    #     if user_signed_in?
    #       my_sites.select{ |s| s.slug == p }.first unless p.nil?
    #     else
    #       Site.find_by_slug(p) unless p.nil?
    #     end
    #   else
    #     Site.find_by_url(request.host)
    #   end
    # end
  end

  private

    def request
      @request
    end

    def params
      @params
    end

end
