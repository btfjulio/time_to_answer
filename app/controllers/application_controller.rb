# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :check_pagination

  protected

  def layout_by_resource
    devise_controller? ? "#{resource_class.to_s.downcase}s_devise" : 'application'
  end

  def check_pagination
    unless user_signed_in?
      params.extract!(:page)
    end
  end
end
