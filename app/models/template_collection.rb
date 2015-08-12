class TemplateCollection

  def initialize(site)
    @site = site
  end

  def all
    templates
  end

  def find(template)
    templates.select { |t| t.name == template }.first
  end

  private

    def templates_root
      "#{Rails.root}/projects/#{@site.slug}/templates"
    end

    def templates
      @templates ||= begin
        templates = []
        Dir.glob("#{templates_root}/*.html.*").each do |t|
          templates << Template.new(t, @site)
        end
        templates
      end
    end

end
