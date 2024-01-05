class BreweriesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show, :active, :retired]
  before_action :set_brewery, only: %i[show edit update destroy]
  before_action :ensure_that_admin, only: [:destroy]

  # GET /breweries or /breweries.json
  def index
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    # @breweries = Brewery.all
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
    return unless turbo_frame_request?

    render partial: 'new'
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.turbo_stream {
          type = @brewery.active ? "active" : "retired"
          count = @brewery.active ? Brewery.active.count : Brewery.retired.count
          render turbo_stream:
                   [turbo_stream.append("#{type}_brewery_rows", partial: "brewery_row", locals: { brewery: @brewery }),
                    turbo_stream.replace("#{type}_breweries_count", partial: "brewery_count", locals: { count: count })
                   ]
        }
        format.html { redirect_to brewery_url(@brewery), notice: "Brewery was successfully created." }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to brewery_url(@brewery), notice: "Brewery was successfully updated." }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    brewery = @brewery
    @brewery.destroy
    type = brewery.active ? "active" : "retired"
    count = brewery.active ? Brewery.active.count : Brewery.retired.count

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream:
                 [turbo_stream.remove(brewery),
                  turbo_stream.replace("#{type}_breweries_count", partial: "brewery_count", locals: { count: count })
                 ]
      }
      format.html { redirect_to breweries_url, notice: "Brewery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, !brewery.active

    new_status = brewery.active? ? "active" : "retired"

    redirect_to brewery, notice: "brewery activity status changed to #{new_status}"
  end

  def active
    active_breweries = Brewery.active
    render partial: 'breweries', locals: { breweries: active_breweries, type: "active" }
  end

  def retired
    retired_breweries = Brewery.retired
    render partial: 'breweries', locals: { breweries: retired_breweries, type: "retired" }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def brewery_params
    params.require(:brewery).permit(:name, :year, :active)
  end
end
