class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :before_filter
  
  def before_filter
    @system = {
      :eval_template => true,
      :user_type => :admin
    }
  end
end
