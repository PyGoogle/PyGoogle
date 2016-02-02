class PlusController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!
  def index
  end
  def second
  end
end
