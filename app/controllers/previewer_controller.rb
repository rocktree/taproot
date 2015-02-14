class PreviewerController < Viewer::PagesController

  # before_filter :authenticate_user!

  def dashboard
    redirect_to builder_sites_path
  end

end
