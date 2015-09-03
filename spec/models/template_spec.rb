require 'rails_helper'

describe Template do

  before :all do
    @site = Site.find_or_create_by(:title => 'Hello World 123')
    config = YAML.load_file("#{Rails.root}/spec/support/config_01.yml")
    @site.update_config(config)
    @home = @site.templates.find('home')
  end

  it 'has a name' do
    expect(@home.name).to eq('home')
  end

  it 'has a hash of attributes' do
    expect(@home.attributes[:title]).to eq('Home')
  end

  it 'adds the name to the attributes' do
    expect(@home.attributes[:name]).to eq('home')
  end

  it 'loads the attributes as pseudo methods' do
    expect(@home.title).to eq('Home')
  end

  it 'loads all fields into a collection' do
    expect(@home.fields.class).to eq(TemplateFieldCollection)
  end

  it 'is showable (not a block) if not specified' do
    expect(@home.showable?).to eq(true)
  end

  it 'is showable (not a block) if specified' do
    expect(@site.templates.find('about').showable?).to eq(true)
  end

  it 'is a block (not showable) if specified' do
    expect(@site.templates.find('feature').block?).to eq(true)
  end

end
