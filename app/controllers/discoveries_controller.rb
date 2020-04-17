class DiscoveriesController < ApplicationController
  def index
    @discoveries = Discovery.all
  end

  def show
    @discovery = Discovery.find(params[:id])
  end

  def new
    @discovery = Discovery.new
  end

  def create
    @discovery = Discovery.new(discovery_params)
      if @discovery.save
        flash[:info] = "投稿しました"
        redirect_to discoveries_path
      else
        render "new"
      end
  end

  def edit
  end

  private
    def discovery_params
      params.require(:discovery).permit(:content)
    end
end
