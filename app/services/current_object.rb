class CurrentObject

  def initialize(request, params)
    @request = request
    @params = params
  end

  def site
    @site ||= params[:site_uid] ? Site.find_by_uid(params[:site_uid]) : nil
  end

  private

    def request
      @request
    end

    def params
      @params
    end

end
