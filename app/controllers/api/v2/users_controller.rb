class Api::V2::UsersController < Api::V2::BaseController

  def create
    user = eval(params['user'])
    @user = User.new(
      :name => user[:name],
      :email => user[:email],
      :password => user[:password],
      :password_confirmation => user[:password_confirmation],
      :admin => user[:admin],
    )
    if @user.save
      render :json => @user, :status => 200
    else
      render :json => @user.errors.messages, :status => 500
    end
  end

end
