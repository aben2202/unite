class ApplicationController < ActionController::Base
  protect_from_forgery
  include ActivitiesHelper
  include CommentsHelper
  include GroupsHelper
end
