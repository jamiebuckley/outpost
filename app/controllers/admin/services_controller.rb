class Admin::ServicesController < Admin::BaseController
  before_action :set_service, only: [:show, :update, :destroy]

  def index
    @query = params.permit(:order, :order_by, :filter_taxonomy, :filter_status, :archived, :query)

    @services = Service.page(params[:page]).includes(:organisation)

    if params[:archived] === "true"
      @services = @services.discarded
    else
      @services = @services.kept
    end

    @services = @services.where(type: "OfstedService") if params[:ofsted] === "true"

    @services = @services.alphabetical if params[:order] === "asc" && params[:order_by] === "name"
    @services = @services.reverse_alphabetical if params[:order] === "desc" && params[:order_by] === "name"
    @services = @services.newest if params[:order] === "desc" && params[:order_by] === "updated_at"
    @services = @services.oldest if params[:order] === "asc" && params[:order_by] === "updated_at"

    @services = @services.in_taxonomy(params[:filter_taxonomy]) if params[:filter_taxonomy].present?
    @services = @services.tagged_with(params[:filter_label]) if params[:filter_label].present?
    @services = @services.scheduled if params[:filter_status].present? && params[:filter_status] === "scheduled"
    @services = @services.hidden if params[:filter_status].present? && params[:filter_status] === "expired"

    @services = @services.search(params[:query]).page(params[:page]) if params[:query].present?
    @services = @services.order(updated_at: :DESC) # default sort
  end

  def show
    @watched = current_user.watches.where(service_id: @service.id).exists?
    @snapshots = @service.snapshots.order(created_at: :desc).includes(:user)
    if @service.snapshots.length > 4
      @snapshots = @snapshots.first(3)
      @snapshots.push(@service.snapshots.last)
    end
  end

  def update
    # byebug
    if @service.update(service_params)
      redirect_to admin_service_url(@service), notice: "Service has been updated."
    else
      render "show"
    end
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to admin_service_url(@service), notice: "Service has been created."
    else
      render "new"
    end
  end

  def destroy
    @service.archive
    redirect_to admin_services_path, notice: "That service has been archived"
  end

  private

  def set_service
    @service = Service.includes(notes: [:user]).find(params[:id])
  end

  def service_params
    params.require(:service).permit(
      :name,
      :organisation_id,
      :description,
      :url,
      :visible,
      :email,
      :visible_from,
      :visible_to,
      :label_list,
      :needs_referral,
      taxonomy_ids: [],
      # location_ids: [],
      local_offer_attributes: [
        :id,
        :description,
        :link,
        :_destroy,
      ],
      cost_options_attributes: [
        :id,
        :option,
        :amount,
        :_destroy,
      ],
      regular_schedules_attributes: [
        :id,
        :opens_at,
        :closes_at,
        :weekday,
        :_destroy,
      ],
      contacts_attributes: [
        :id,
        :name,
        :title,
        :visible,
        :_destroy,
        phones_attributes: [
          :id,
          :number
        ]
      ],
      locations_attributes: [
        :id,
        :name,
        :address_1,
        :city,
        :postal_code,        
        :visible,
        # :latitude,
        # :longitude,
        # :google_place_id,
        :_destroy,
        accessibility_ids: []
      ]
    )
  end

end