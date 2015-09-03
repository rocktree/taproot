class Builder::Forms::SubmissionsController < Editor::BaseController

  include FormsHelper

  def index
    respond_to do |format|
      format.html
      format.csv { send_data current_form.to_csv }
    end
  end

  def show
  end

  def update
    if current_form_submission.update!(update_params)
      redirect_to(
        builder_route([current_form, current_form_submission], :index),
        :notice => 'Submission updated successfully!'
      )
    else
      render 'edit'
    end
  end

  private

    def update_params
      params.require(:form_submission).permit!
    end

    def builder_html_title
      @builder_html_title ||= begin
        if current_form_submission
          t = current_form_submission.field_data.first.last
          t += " >> #{current_form.title}"
        else
          "Submissions >> #{current_form.title}"
        end
      end
    end

end
