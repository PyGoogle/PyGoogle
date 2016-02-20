class ProjectsController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!
  def home
  end
  def second
  end
  #def skybender
    #render '/projects/skybender'
  #end
end