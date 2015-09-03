class Builder::MenusController < Editor::BaseController

  include MenusHelper

  def index
  end

  def show
  end

  def new
    @current_menu = Menu.new
  end

  def create
    @current_menu = Menu.new(create_params)
    if current_menu.save
      redirect_to(
        builder_route([current_menu], :index),
        :notice => 'Menu created successfully!'
      )
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if current_menu.update(update_params)
      redirect_to(
        builder_route([current_menu], :index),
        :notice => 'Menu updated successfully!'
      )
    else
      render 'edit'
    end
  end

  def destroy
    current_menu.destroy
    redirect_to(
      builder_route([site_menus], :index),
      :notice => 'Menu deleted successfully!'
    )
  end

  private

    def create_params
      params.require(:menu).permit(:title).merge(:site => current_site)
    end

    def update_params
      params.require(:menu).permit(:title)
    end

end
