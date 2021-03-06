# coding: utf-8

module Contentr
  module Admin
    module ApplicationHelper

      def simple_form_for_contentr_paragraph(&block)
        simple_form_for(
          'paragraph',
          :url     => (@paragraph.new_record? ? contentr_admin_paragraphs_path(:page_id => @page.id, :area_name => @area_name, :type => @paragraph.class, :site => params[:site]) : contentr_admin_paragraph_path(:page_id => @page, :id => @paragraph, :site => params[:site])),
          :method  => (@paragraph.new_record? ? :post : :put),
          :enctype => "multipart/form-data",
          :html    => {:class => 'form-horizontal'}) do |f|
            yield(f) # << f.input(:area_name, :as => :hidden)
          end
      end

      def simple_form_for_contentr_file(file, &block)
        simple_form_for(
          'file',
          :url     => (file.new_record? ? contentr_admin_files_path() : contentr_admin_file_path(file)),
          :method  => (file.new_record? ? :post : :put),
          :enctype => "multipart/form-data",
          :html    => {:class => 'form-horizontal'}) do |f|
            yield(f)
          end
      end

    end
  end
end