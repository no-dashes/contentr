module Contentr
  module ApplicationHelper

    # Renders an area of paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_area(area_name)
      contentr_paragraphs(area_name, @contentr_page, nil)
    end

    # Renders an area of paragraphs for site paragraphs
    #
    # @param [String] The name of the area that should be rendered.
    #
    def contentr_site_area(area_name)
      contentr_paragraphs(area_name, @contentr_page, Contentr::Site.default)
    end

    # Renders the contentr toolbar in the page
    def contentr_toolbar(options = {})
      if controller.contentr_authorized?
        content_tag(:div, :class => 'contentr toolbar') do
          s = ''.html_safe
          s << 'NOT PUBLISHED ' if @contentr_page and not @contentr_page.published
          s << 'HIDDEN ' if @contentr_page and @contentr_page.hidden
          s << link_to('Pages', contentr_admin_pages_url, :rel => 'contentr-overlay')
        end
      end
    end

    # Inserts Google Anylytics into the page
    def contentr_google_analytics
      if Contentr.google_analytics_account.present?
        s = <<-HTML
          <script type="text/javascript">

           var _gaq = _gaq || [];
           _gaq.push(['_setAccount', '##ID##']);
           _gaq.push(['_trackPageview']);

           (function() {
             var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
             ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
             var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
           })();

          </script>
        HTML
        s.gsub!('##ID##', Contentr.google_analytics_account)
        s.html_safe
      end
    end

    private

    def contentr_paragraphs(area_name, current_page, site)
      if current_page.present? and area_name.present?
        area_name  = area_name.to_s
        if site.present?
          paragraphs = site.paragraphs_for_area(area_name)
        else
          paragraphs = current_page.paragraphs_for_area(area_name)
        end
        authorized = controller.contentr_authorized?

        area_options = {}
        area_classes = []
        area_classes << 'contentr'
        area_classes << 'area'
        area_classes << 'editable' if authorized
        area_options[:class] = area_classes.join(' ')
        area_options['data-contentr-area'] = area_name
        area_options['data-contentr-page'] = current_page.id

        content_tag(:div, area_options) do
          s = ''.html_safe

          if authorized
            s << content_tag(:div, :class => 'contentr toolbar') do
              t = ''.html_safe
              t << area_name
              t << ' | '
              t << link_to('new', contentr_admin_new_paragraph_path(:page_id => current_page, :area_name => area_name, :site => site.present?), :rel => 'contentr-overlay')
              t
            end
          end

          # Render paragraphs
          s << paragraphs.collect do |p|
            template_name = p.class.to_s.tableize.singularize

            paragraph_options = {}
            paragraph_classes = []
            paragraph_classes << 'contentr'
            paragraph_classes << 'paragraph'
            paragraph_classes << 'editable' if authorized
            paragraph_options[:class] = paragraph_classes.join(' ')
            paragraph_options[:id] = "paragraph_#{p.id}"

            content_tag(:div, paragraph_options) do
              s = ''.html_safe

              if authorized
                s << content_tag(:div, :class => 'contentr toolbar') do
                  t = ''.html_safe
                  t << link_to(contentr_admin_edit_paragraph_path(:page_id => current_page, :id => p, :site => site.present?), :rel => 'contentr-overlay') do
                    "edit"
                  end
                  t << ' | '
                  t << link_to(contentr_admin_paragraph_path(:page_id => current_page, :id => p, :site => site.present?), :method => :delete, :confirm => 'Really delete?') do
                    "delete"
                  end
                  t
                end
              end

              s << render(:partial => "contentr/paragraphs/#{template_name}", :locals => {:paragraph => p})
            end
          end.join('').html_safe
        end
      end
    end

  end
end