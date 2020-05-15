class FavoritesController < ApplicationController
  before_action :user_logged_in?

  def create
    discovery = Discovery.find(params[:discovery_id])
    current_user.favo(discovery)
    if params[:page] == "index"
    redirect_to discoveries_path
    else
      redirect_to discovery_path(discovery)
    end
    end

  def destroy
    discovery = Favorite.find(params[:id]).discovery
    current_user.unfavorite(discovery)
    if params[:page] == "index"
    redirect_to discoveries_path
    else
      redirect_to discovery_path(discovery)
    end
  end
end
