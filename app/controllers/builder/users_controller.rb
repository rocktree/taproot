class Builder::UsersController < Editor::BaseController

  before_action :set_user, :except => [:index, :create]

  def index
  end

  def new
  end

  def show
    @user = User.find_by_id(params[:id])
    redirect_to builder_route([@user], :edit)
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    @user = User.create!(create_params) if @user.nil?
    if @user.save
      @site_user = SiteUser.create!(:user => @user,
        :site => current_site)
      if @site_user.save
        redirect_to(builder_route([@user], :index),
          :notice => t('notices.created', :item => "User"))
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    p ||= create_params
    if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
      p = create_params.except("password", "password_confirmation")
    end
    if @user.update(p)
      if @user == current_user && p[:password].present?
        sign_in(@user, :bypass => true)
      end
      redirect_to(
        builder_route([@user], :index),
        :notice => t('notices.updated', :item => "User")
      )
    else
      render 'edit'
    end
  end

  def edit
  end

  def destroy
    site_users = SiteUser.where(:user_id => params[:id])
    site_users.destroy_all
    redirect_to(builder_route([@user], :index),
      :notice => t('notices.deleted', :item => "User"))
  end

  private

    def set_user
      if action_name == 'new'
        @user = User.new(params[:user] ? create_params : nil)
      else
        @user = User.find_by_id(params[:id])
      end
      not_found if @user.nil?
    end

    def create_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'index'
          "Users >> #{current_site.title}"
        when 'edit', 'update'
          set_user
          "Edit >> #{@user.display_name}"
        when 'new', 'create'
          "New User"
        end
      end
    end

end
