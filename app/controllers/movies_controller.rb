class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    if !params.include?(:ratings) or !params.include?(:sortby)  # if missing info from user, fill from session
      if !params.include?(:ratings)
        @ratings_selected = session.include?(:ratings)?session[:ratings]:{'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1', 'NC-17'=>'1'}
      else
        @ratings_selected = params[:ratings]
      end
      if !params.include?(:sortby)
        @sortby = session.include?(:sortby)?session[:sortby]:"title"
      else
        @sortby = params[:sortby]
      end
      session = {:ratings=>@ratings_selected, :sortby=@sortby}
      flash.keep
      redirect_to movies_path(:sortby => @sortby, :ratings => @ratings_selected)      
    end
#    @all_ratings=['G','PG','PG-13','R', 'NC-17']
    # if session.include?(:ratings)
      # @ratings_selected = session[:ratings]
    # else
      # @ratings_selected = {'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1', 'NC-17'=>'1'}
    # end
#     
    # if session.include?(:sortby)
      # @sortby = session[:sortby]
    # end
#     
    if params.include?(:ratings) and params.include?(:sortby)
      @ratings_selected = params[:ratings]
      @sortby = params[:sortby]
#      @movies = Movie.where(:rating => @ratings_selected.keys).order(@sortby)
      @movies = Movie.find(:all, :conditions => { :rating => @ratings_selected.keys}, :order => @sortby)
    elsif params.include?(:ratings)
      @ratings_selected = params[:ratings]
      @movies = Movie.find(:all, :conditions => { :rating => @ratings_selected.keys})
#      @movies = Movie.find(:all, :rating => @ratings_selected.keys)
    elsif params.include?(:sortby)
      @sortby = params[:sortby]
      @movies = Movie.find(:all, :order => @sortby)
    else
      @movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
