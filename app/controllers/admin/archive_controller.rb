class Admin::ArchiveController < Admin::BaseController
    def index
        @services = Service.discarded.order(discarded_at: :DESC).page(params[:page]).includes(:taxonomies, :organisation)
    end

    def update
        @service = Service.find(params[:id])
        @service.restore
        redirect_to request.referer, notice: "Service has been restored."
    end
end