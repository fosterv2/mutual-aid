class ExternalResourcesController < ApplicationController
  before_action :set_external_resource, only: [:show, :edit, :update, :destroy]

  def index
    @external_resources = ExternalResource.all
  end

  def show
  end

  def new
    @external_resource = ExternalResource.new
  end

  def edit
  end

  def create
    @external_resource = ExternalResource.new(external_resource_params)

    respond_to do |format|
      if @external_resource.save
        format.html { redirect_to external_resources_path, notice: 'External resource was successfully created.' }
        format.json { render :show, status: :created, location: @external_resource }
      else
        format.html { render :new }
        format.json { render json: @external_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @external_resource.update(external_resource_params)
        format.html { redirect_to external_resources_path, notice: 'External resource was successfully updated.' }
        format.json { render :index, status: :ok, location: @external_resource }
      else
        format.html { render :edit }
        format.json { render json: @external_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @external_resource.destroy
    respond_to do |format|
      format.html { redirect_to external_resources_url, notice: 'External resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_resource
      @external_resource = ExternalResource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def external_resource_params
      params.require(:external_resource).permit(:name, :website_url, :facebook_url,
                                                :phone, :description, :display_on_website,
                                                :youtube_identifier, :location_id, tags: [])
    end
end