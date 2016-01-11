class Admin::OperationsController < ApplicationController
  before_filter :require_login
  before_filter do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_OPERATIONS))
  end
  before_filter :only => [:show, :edit] do |c|
    c.send(:enforce, [Operation.find(params[:id]).associated_crews.include?(current_person.current_crew), "You may not view an operation that does not involve your crew."])
  end
  before_filter :only => [:update, :destroy] do |c|
    c.send(:enforce, Operation.find(params[:id]).crew == current_person.current_crew)
  end

  def show
    @operation = Operation.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @operation }
    end
  end

  # GET /admin/operations/new
  # GET /admin/operations/new.xml
  def new
    @operation = Operation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @operation }
    end
  end

  # GET /admin/operations/1/edit
  def edit
    @operation = Operation.find(params[:id])
  end

  # POST /admin/operations
  # POST /admin/operations.xml
  def create
    @operation = Operation.new(params[:operation])
    #set the creator id here rather than on the form for security purposes.
    @operation.creator_id = current_person.id
    @operation.rappels.each { |r| r.set_confirmation(current_person) }
    #save the fullname that was entered so that we can repopulate the form with it in the event of an error.  We
    #must do this manually because the model doesn't actually save the spotter's name, it saves their id.
    @spotter_fullname = params[:spotter_fullname]

    respond_to do |format|
      if @operation.save
        format.html { redirect_to(admin_operation_url(@operation), :notice => 'Operation was successfully created.') }
        format.xml  { render :xml => @operation, :status => :created, :location => @operation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/operations/1
  # PUT /admin/operations/1.xml
  def update
    @operation = Operation.find(params[:id])

    respond_to do |format|
      if @operation.update_attributes(params[:operation])
        format.html { redirect_to(@operation, :notice => 'Operation was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operation.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /admin/operations/1
  # DELETE /admin/operations/1.xml
  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy

    respond_to do |format|
      format.html { redirect_to(operations_url) }
      format.xml  { head :ok }
    end
  end
end
