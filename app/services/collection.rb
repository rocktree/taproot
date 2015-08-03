class Collection

  def initialize(request, params)
    @request = request
    @params = params
  end

  def all_sites
    @all_sites ||= Site.all
  end

  private

    def request
      @request
    end

    def params
      @params
    end

end
