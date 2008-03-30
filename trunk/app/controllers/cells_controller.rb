class CellsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @cell_pages, @cells = paginate :cells, :per_page => 10
  end

  def show
    @cell = Cell.find(params[:id])
  end

  def new
    @cell = Cell.new
  end

  def create
    @cell = Cell.new(params[:cell])
    if @cell.save
      flash[:notice] = 'Cell was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @cell = Cell.find(params[:id])
  end

  def update
    @cell = Cell.find(params[:id])
    if @cell.update_attributes(params[:cell])
      flash[:notice] = 'Cell was successfully updated.'
      redirect_to :action => 'show', :id => @cell
    else
      render :action => 'edit'
    end
  end

  def destroy
    Cell.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  

  
end
