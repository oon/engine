module Locomotive
  class ImportController < BaseController

    sections 'settings', 'site'

    skip_load_and_authorize_resource

    before_filter :authorize_import

    def show
      @import = Locomotive::Import::Model.current(current_site)
      respond_with @import
    end

    def new
      @import = Locomotive::Import::Model.new
      respond_with @import
    end

    def create
      @import = Locomotive::Import::Model.create(params[:import].merge(:site => current_site))
      respond_with @import, :location => Locomotive.config.delayed_job ? import_url : new_import_url
    end

    protected

    def authorize_import
      authorize! :import, Site
    end

  end
end


# begin
#   Locomotive::Import::Job.run!(params[:zipfile], current_site, {
#     :samples  => Boolean.set(params[:samples]),
#     :reset    => Boolean.set(params[:reset])
#   })
#
#   flash[:notice] = t("fash.locomotive.import.create.#{Locomotive.config.delayed_job ? 'notice' : 'done'}")
#
#   redirect_to Locomotive.config.delayed_job ? import_url : new_import_url
# rescue Exception => e
#   logger.error "[Locomotive import] #{e.message} / #{e.backtrace}"
#
#   @error = e.message
#   flash[:alert] = t('fash.locomotive.import.create.alert')
#
#   render 'new'
# end

# def show
#   @job = Delayed::Job.where({ :job_type => 'import', :site_id => current_site.id }).last
#
#   respond_to do |format|
#     format.html do
#       redirect_to new_import_url if @job.nil?
#     end
#     format.json { render :json => {
#       :step => @job.nil? ? 'done' : @job.step,
#       :failed => @job && @job.last_error.present?
#     } }
#   end
# end