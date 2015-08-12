require 'rails_helper'

describe TemplateCollection do

  before :all do
    @site = Site.find_or_create_by(
      :title => 'Hello World 123',
      :slug => 'hello-world-123',
      :git_url => 'git@github.com:topicdesign/topkit-test-template.git',
      :uid => '69b0386a13b44503881d516a2c19cc4a2bf48974d552a397'
    )
    system("cd #{Rails.root}/projects && git clone #{@site.git_url} #{@site.slug}")
  end

  it 'instantiates an object of the template class' do
    expect(@site.templates.class).to eq(TemplateCollection)
  end

  it 'loads all templates into a collection' do
    expect(@site.templates.all.size).to eq(2)
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

end