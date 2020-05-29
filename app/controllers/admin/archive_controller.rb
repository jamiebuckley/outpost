class Admin::ArchiveController < Admin::BaseController
    before_action :set_service, only: [:update, :destroy]

    def index
        @services = Service.discarded.order(discarded_at: :DESC).page(params[:page]).includes(:taxonomies, :organisation)
    end

    def update
        @service.restore
        redirect_to request.referer, notice: "Service has been restored."
    end

    def destroy
        @service.mark_for_deletion
        redirect_to request.referer, notice: "Service will be deleted permenantly in 30 days. Speak to an administrator if this was a mistake."
    end

    private

    def set_service
        @service = Service.find(params[:id])
    end
end