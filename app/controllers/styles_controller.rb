class StylesController < ApplicationController
  before_action :set_style, only: %i[show edit update destroy]
  before_action :ensure_that_admin, only: [:destroy]

  def index
    # now this takes only care of the full page reloads
    @styles = Style.all
  end

  def show
    return unless turbo_frame_request?

    render partial: 'details', locals: { style: @style }
  end

  # def about
  #   render partial: 'about'
  # end

  def destroy
    style = Style.find(params[:id])
    style.destroy

    redirect_to styles_path
  end

  def set_style
    @style = Style.find(params[:id])
  end
end
