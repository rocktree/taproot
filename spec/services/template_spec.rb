require 'rails_helper'

describe Template do

  before :all do
    @site = Site.find_or_create_by(
      :title => 'Hello World 123',
      :slug => 'hello-world-123',
      :git_url => 'git@github.com:topicdesign/topkit-test-template.git',
      :uid => '69b0386a13b44503881d516a2c19cc4a2bf48974d552a397'
    )
    # @template = "#{Rails.root}/spec/support/basic_template.html.erb"
    # @response = Frontmatter.parse(@template)
    system("cd #{Rails.root}/projects && git clone #{@site.git_url}")
  end

  it 'instantiates an object of the template class' do
    expect(@site.templates.class).to eq(Template)
  end

  it 'can return a list of available template names' do
    expect(@site.templates.all).to eq(['home', 'about'].sort)
  end

end