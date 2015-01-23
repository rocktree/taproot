Site.all.each do |site|
  unless site.url.blank?
    SitemapGenerator::Sitemap.default_host = "http://#{site.url}"
    SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{site.slug}"
    SitemapGenerator::Sitemap.create do
      site_pages = site.pages
      (site_pages - [site.home_page]).each do |page|
        path = ''
        page.ancestor_ids.each do |id|
          path += site_pages.select { |p| p.id == id.to_i }.first.slug + '/'
        end
        add(path + page.slug)
      end
    end
  end
end
