class SubscriptionsController < ApplicationController
  def create
  	@category = Category.find(params[:subscription][:category_id])
    current_user.subscribe!(@category)
    redirect_to :back
  end

  def destroy
    @category = Subscription.find(params[:id]).category
    current_user.unsubscribe!(@category)
    redirect_to :back
  end
end
