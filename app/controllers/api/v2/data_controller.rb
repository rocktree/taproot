class Api::V2::DataController < Api::V2::BaseController

  def export
    begin
      system("RAILS_ENV=#{Rails.env} bundle exec rake db:data:dump")
      render :text => File.read("#{Rails.root}/db/data.yml"), :status => 200
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

end
