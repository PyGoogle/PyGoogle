class YoutubeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!
  def home
  end

  def another
  end

  def extract_iframe
  end

end
