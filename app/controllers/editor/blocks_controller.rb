class Editor::BlocksController < Editor::BaseController

  before_filter :verify_xhr, :only => [:index]

  def index
    @blocks = []
    current_site.webpages.where(:template_name => params[:t]).each do |block|
      @blocks << Block.new(
        :page => current_page,
        :block => block,
        :title => params[:b]
      )
    end
    render :layout => false
  end

  def create
    @current_block = Block.create(create_params)
    if current_block.save
      redirect_to redirect_route, :notice => 'Block added!'
    else
      redirect_to redirect_route, :notice => 'Block could not be added.'
    end
  end

  def destroy
    block_page = find_page(params[:slug])
    block = Block.find_by(:page => current_page, :block => block_page)
    block.destroy
    redirect_to redirect_route, :notice => 'Block removed'
  end

  private

    def create_params
      params.require(:block).permit(:title, :page_id, :block_id)
    end

    def update_params
      params.require(:block).permit(:position)
    end

end
