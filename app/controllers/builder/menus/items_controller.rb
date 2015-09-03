class Builder::Menus::ItemsController < Editor::BaseController

  include MenusHelper

  def index
  end

  def show
    @menu_items = current_menu_item.children.in_position
  end

  def new
    @current_menu_item = MenuItem.new
  end

  def create
    @current_menu_item = MenuItem.new(create_params)
    if current_menu_item.save
      redirect_to(redirect_route, :notice => 'Menu item created successfully!')
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      format.html do
        if current_menu_item.update(update_params)
          redirect_to(
            redirect_route,
            :notice => 'Menu item updated successfully!'
          )
        else
          render 'edit'
        end
      end
      format.json do
        current_menu_item.update!(update_params)
        render :nothing => true
      end
    end
  end

  def destroy
    current_menu_item.destroy
    redirect_to(redirect_route, :notice => 'Menu item deleted successfully!')
  end

  private

    def create_params
      params.require(:menu_item).permit(:page_id, :title, :url, :in_list)
        .merge(:menu => current_menu)
    end

    def update_params
      params.require(:menu_item).permit(:page_id, :title, :url, :position)
    end

    def redirect_route
      if current_menu_item.is_root?
        builder_route([current_menu, current_menu_item], :index)
      else
        builder_route([current_menu, current_menu_item.parent], :show)
      end
    end

end
