class StylesController < ApplicationController
  before_action :set_style, only: %i[show]
  before_action :ensure_that_admin, only: [:destroy]
  def index
    @styles = Style.all
  end

  def show
  end

  def destroy
    style = Style.find(params[:id])
    style.destroy

    redirect_to styles_path
  end
  def set_style
    @style = Style.find(params[:id])
  end

end