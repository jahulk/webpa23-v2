class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @recent_ratings = Rating.recent
    @best_beers = Beer.best_beers
    @best_breweries = Brewery.best_breweries
    @best_styles = Style.best_styles
    @most_active_users = User.most_active
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
    rating.delete if current_user == rating.user

    redirect_to user_path(current_user)

    # respond_to do |format|
    #   format.html { redirect_to ratings_path, notice: "Rating was successfully destroyed." }
    #   format.json { head :no_content }

    # redirect_to ratings_path
  end
end
