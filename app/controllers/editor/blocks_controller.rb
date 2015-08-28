class Editor::BlocksController < Editor::BaseController

  def destroy
    block_page = find_page(params[:slug])
    block = Block.find_by(:page => current_page, :block => block_page)
    block.destroy
    redirect_to redirect_route, :notice => 'Block removed'
  end

end
