class RatingsController < ApplicationController
  PAGE_SIZE = 5

  def index
    # @recent_ratings = Rating.recent
    @best_beers = Beer.best_beers
    @best_breweries = Brewery.best_breweries
    @best_styles = Style.best_styles
    @most_active_users = User.most_active

    @order = params[:order] || "desc"
    @page = params[:page]&.to_i || 1
    @last_page = (1.0 * Rating.count / PAGE_SIZE).ceil
    offset = (@page - 1) * PAGE_SIZE

    @ratings = case @order
               when "desc" then Rating.order(created_at: :desc).limit(PAGE_SIZE).offset(offset)
               when "asc" then Rating.order(created_at: :asc).limit(PAGE_SIZE).offset(offset)
               end
  end

  def show
    @rating = Rating.find(params[:id])
    return unless turbo_frame_request?

    render partial: 'details', locals: { rating: @rating }
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
    destroy_ids = request.body.string.split(',')
    destroy_ids.each do |id|
      rating = Rating.find(id)
      rating.destroy if rating && current_user == rating.user
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end

    @user = current_user
    respond_to do |format|
      format.html { render partial: '/users/ratings', status: :ok, user: @user }
    end

    # respond_to do |format|
    #   format.html { redirect_to ratings_path, notice: "Rating was successfully destroyed." }
    #   format.json { head :no_content }

    # redirect_to ratings_path
  end
end
