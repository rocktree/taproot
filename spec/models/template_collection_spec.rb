require 'rails_helper'

describe TemplateCollection do

  before :all do
    @site = Site.find_or_create_by(:title => 'Hello World 123')
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
  end

  it 'instantiates an object of the template class' do
    expect(@site.templates.class).to eq(TemplateCollection)
  end

  it 'loads all templates into a collection' do
    expect(@site.templates.all.size).to eq(3)
  end

  it 'loads a collection of templates' do
    expect(@site.templates.all.first.class).to eq(Template)
  end

  it 'can find a specific template' do
    expect(@site.templates.find('home').class).to eq(Template)
  end

  it 'returns nil if it can not find a template' do
    expect(@site.templates.find('missing-template')).to eq(nil)
  end

  it 'returns an empty array for `all` if there are no templates' do
    site = create(:site)
    expect(site.templates.all).to eq([])
  end

end