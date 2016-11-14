class PhotosController < ApplicationController
  before_action :current_user_must_be_photo_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_photo_user
    photo = Photo.find(params[:id])

    unless current_user == photo.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @photos = Photo.page(params[:page])

    render("photos/index.html.erb")
  end

  def show
    @photo = Photo.find(params[:id])

    render("photos/show.html.erb")
  end

  def new
    @photo = Photo.new

    render("photos/new.html.erb")
  end

  def create
    @photo = Photo.new

    @photo.user_id = params[:user_id]

    save_status = @photo.save

    if save_status == true
      redirect_to("/photos/#{@photo.id}", :notice => "Photo created successfully.")
    else
      render("photos/new.html.erb")
    end
  end

  def edit
    @photo = Photo.find(params[:id])

    render("photos/edit.html.erb")
  end

  def update
    @photo = Photo.find(params[:id])

    @photo.user_id = params[:user_id]

    save_status = @photo.save

    if save_status == true
      redirect_to("/photos/#{@photo.id}", :notice => "Photo updated successfully.")
    else
      render("photos/edit.html.erb")
    end
  end

  def destroy
    @photo = Photo.find(params[:id])

    @photo.destroy

    if URI(request.referer).path == "/photos/#{@photo.id}"
      redirect_to("/", :notice => "Photo deleted.")
    else
      redirect_to(:back, :notice => "Photo deleted.")
    end
  end
end
