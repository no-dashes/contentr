module Contentr
  module Rendering

    def contentr(*keys)
      if keys.present?
        @contentr_page ||= Contentr::LinkedPage.find_by_keys keys
      else
        @contentr_page ||= Contentr::LinkedPage.find_by_request_params(params)
      end
    end

    def contentr!(*keys)
      contentr(*keys)
      raise ActionController::RoutingError.new("No Contentr Page for #{keys} found.") unless @contentr_page
    end

    def contentr_page
      @contentr_path = params[:contentr_path] or raise "Need a 'contentr_path' parameter!"

      #
      # Contentr rendering
      #
      path = ::File.join(Contentr.default_site, @contentr_path)
      @contentr_page = Contentr::Page.find_by_path(@contentr_path) || Contentr::Page.find_by_path(path)
      if @contentr_page.present? && (@contentr_page.published || contentr_authorized?) && !@contentr_page.menu_only?
        if @contentr_page.is_a?(Contentr::LinkedPage)
          return redirect_to @contentr_page.url, status: :moved_permanently
        else
          options[:template] = @contentr_page.template
          options[:layout]   = "layouts/#{@contentr_page.layout}"
        end
        render options
      else
        raise ActionController::RoutingError.new(@contentr_path)
      end
    end
  end
end
