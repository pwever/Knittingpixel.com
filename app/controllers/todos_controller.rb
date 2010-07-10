class TodosController < ApplicationController

  skip_before_filter :verify_authenticity_token

  # GET /todos
  # GET /todos.xml
  def index
    
    sql = "DATE(done_at)==DATE('NOW') OR (done='f' AND (DATE(due_at)<=DATE('NOW') OR (due_at IS NULL)))"
    @todos = Todo.find(:all, :conditions => [sql,false], :order => "due_at")
    @todos.sort!
    
    respond_to do |format|
      format.html
      format.js
      format.xml {  render :xml => @todos }
    end
  end

  # GET /todos/1
  # GET /todos/1.xml
  def show
    @todo = Todo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @todo }
    end
  end
  
  def search
    @todos = Todo.find(:all, :conditions => ["label LIKE ?", "%"+params[:needle]+"%"])
    if @todos.length==0
      flash.now[:notice] = "No matching Todos found."
    end
    render :action => 'index'
  end

  # GET /todos/new
  # GET /todos/new.xml
  def new
    @todo = Todo.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @todo }
    end
  end

  # GET /todos/1/edit
  def edit
    @todo = Todo.find(params[:id])
  end

  # POST /todos
  # POST /todos.xml
  def create
    @todo = Todo.new(params[:todo])

    respond_to do |format|
      if @todo.save
        flash[:notice] = 'Todo was successfully created.'
        format.html { redirect_to(@todo) }
        format.xml  { render :xml => @todo, :status => :created, :location => @todo }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
        format.js { render :text => 'error' }
      end
    end
  end

  # PUT /todos/1
  # PUT /todos/1.xml
  def update
    @todo = Todo.find(params[:id])

    respond_to do |format|
      if @todo.update_attributes(params[:todo])
        flash[:notice] = 'Todo was successfully updated.'
        format.html { redirect_to(@todo) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
        format.js { render :text => 'error' }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.xml
  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to(todos_url) }
      format.xml  { head :ok }
      format.js   { render :text => 'ok' }
    end
  end
end
