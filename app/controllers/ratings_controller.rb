class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
    # rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    # rating.user = current_user
    # rating.save
    # redirect_to current_user
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete

    respond_to do |format|
      format.html { redirect_to ratings_path, notice: "Rating was successfully destroyed." }
      format.json { head :no_content }
    end

    # redirect_to ratings_path
  end
end
