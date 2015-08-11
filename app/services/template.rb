class Template

  def initialize(site)
    @site = site
  end

  def all
    filenames
  end

  private

    def site_root
      "#{Rails.root}/projects/#{@site.slug}"
    end

    def filenames
      templates = Dir.glob("#{site_root}/templates/*.html.*")
        .collect { |t| t.split('/').last.split('.').first }
        .sort
    end

end
