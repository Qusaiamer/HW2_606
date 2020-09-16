class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  

  def index
    
    #Remember changes using session 
    redirect = false
    
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    elsif session[:sort_by] and !params[:sort_by]
      params[:sort_by] = session[:sort_by]
      redirect = true
    elsif !session[:sort_by] and !params[:sort_by]
       
      params[:sort_by] = {}
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings] and !params[:ratings]
      params[:ratings] = session[:ratings]
      redirect = true
    elsif !session[:ratings] and !params[:ratings]
      params[:ratings] = {}
    end
    # Reload to the remembered instance
    if redirect
      flash.keep
      redirect_to movies_path :sort_by => params[:sort_by], :ratings => params[:ratings]
    end
      
    #Define ratings options 
    @all_ratings = Movie.all_ratings
      
    #Assign checked boxes to ratings 
    if params[:ratings].nil?
      params[:ratings] = Hash.new
      @all_ratings.each do |rating|
        params[:ratings][rating] = 1
      end
    end
    
  #Select ratings and sorting
    if params[:ratings] or params[:sort_by]
      @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_by])
    elsif params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys)
      
    elsif params[:sort_by]
      @movies = Movie.order(params[:sort_by])
      
    else
      @movies = Movie.all
    end
      

  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
