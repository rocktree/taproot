class Api::V2::UsersController < Api::V2::BaseController

  def create
    begin
      user = eval(params['user'])
      @user = User.new(
        :name => user[:name],
        :email => user[:email],
        :password => user[:password],
        :password_confirmation => user[:password_confirmation]
      )
      if @user.save
        render :json => @user, :status => 200
      else
        render :json => @user.errors.messages, :status => 500
      end
    rescue Exception => e
      render :json => { 'ERROR' => e.message }, :status => 500
    end
  end

end
