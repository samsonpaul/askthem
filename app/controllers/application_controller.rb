class ApplicationController < ActionController::Base
  # rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
  protect_from_forgery

  def default_jurisdiction
    return @default_jurisdiction if @default_jurisdiction
    abbreviation = if current_user && current_user.region
                     current_user.region
                   elsif request.location &&
                       request.location.coordinates != [0,0] &&
                       OpenGovernment::STATES.values.include?(request.location.state_code.downcase)
                     request.location.state_code.downcase
                   else
                     "ny"
                   end
    @default_jurisdiction = Metadatum.find_by_abbreviation(abbreviation)
  end

  helper_method :default_jurisdiction

  # @see http://robert-reiz.com/2012/07/09/ssl-in-ruby-on-rails/
  # third party resources make https everywhere problematic
  # before_filter set on individual controllers
  def force_http
    if request.protocol == "https://"
      flash.keep
      location_options = { protocol: "http://", status: :moved_permanently }
      location_options = location_options.merge(request.query_parameters)
      redirect_to location_options
    end
  end

  private
  def not_found
    respond_to do |format|
      format.html do
        expires_in 1.hour, public: true
        render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false
      end
      format.json { head :not_found }
      format.atom { head :not_found }
    end
  end
end
