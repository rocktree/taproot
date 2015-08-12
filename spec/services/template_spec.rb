require 'rails_helper'

describe Template do

  before :all do
    @site = Site.find_or_create_by(
      :title => 'Hello World 123',
      :slug => 'hello-world-123',
      :git_url => 'git@github.com:topicdesign/topkit-test-template.git',
      :uid => '69b0386a13b44503881d516a2c19cc4a2bf48974d552a397'
    )
    system("cd #{Rails.root}/projects && git clone #{@site.git_url} #{@site.slug}")
    @home = @site.templates.find('home')
  end

  it 'has a name as the filename without the extension' do
    expect(@home.name).to eq('home')
  end

  it 'holds the filename as an attribute' do
    expect(@home.filename).to eq('home.html.erb')
  end

  it 'has a hash of attributes' do
    expect(@home.attributes[:title]).to eq('Home')
  end

  it 'loads the frontmatter as pseudo methods' do
    expect(@home.title).to eq('Home')
  end

  it 'loads all fields into a collection' do
    expect(@home.fields.class).to eq(TemplateFieldCollection)
  end

end
