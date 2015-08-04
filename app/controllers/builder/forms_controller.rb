class Builder::FormsController < Editor::BaseController

  before_filter :verify_admin, :except => [:index, :show]

  include FormsHelper

  def index
  end

  def show
    redirect_to(builder_route([current_form, current_form_submissions], :index))
  end

  def new
    @current_form = Form.new
  end

  def create
    @current_form = Form.new(form_params)
    if current_form.save
      redirect_to builder_route([current_form], :index),
        :notice => t('notices.created', :item => 'Form')
    else
      render 'new'
    end
  end

  def update
    if current_form.update(form_params)
      redirect_to builder_route([current_form], :edit),
        :notice => t('notices.updated', :item => 'Form')
    else
      render 'edit'
    end
  end

  def destroy
    current_form.destroy
    redirect_to builder_route([site_forms], :index),
      :notice => t('notices.deleted', :item => 'Form')
  end

  private

    def form_params
      params.require(:form).permit(
        :title,
        :button_label,
        :description,
        :body,
        :thank_you_body,
        :notification_emails,
        :email_subject,
        :email_body,
        :email_to_id,
        :form_fields_attributes => [
          :id,
          :title,
          :data_type,
          :position,
          :required,
          :options,
          :slug,
          :label,
          :placeholder,
          :default_value,
          :show_label,
        ]
      ).merge(
        :site => current_site
      )
    end

    def builder_html_title
      @builder_html_title ||= begin
        case action_name
        when 'index'
          "Forms >> #{current_site.title}"
        when 'edit', 'update'
          "Edit #{current_form.title}"
        when 'new', 'create'
          "New Form"
        when 'show'
          "Submissions >> #{current_form.title}"
        end
      end
    end

end
