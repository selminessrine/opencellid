class OperatorsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @operators_pages, @operators = paginate :operators, :per_page => 10
  end

  def show
    @operators = Operators.find(params[:id])
  end

  def new
    @operators = Operators.new
  end

  def create
    @operators = Operators.new(params[:operators])
    if @operators.save
      flash[:notice] = 'Operators was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @operators = Operators.find(params[:id])
  end

  def update
    @operators = Operators.find(params[:id])
    if @operators.update_attributes(params[:operators])
      flash[:notice] = 'Operators was successfully updated.'
      redirect_to :action => 'show', :id => @operators
    else
      render :action => 'edit'
    end
  end

  def destroy
    Operators.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
