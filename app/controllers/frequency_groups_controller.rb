class FrequencyGroupsController < ApplicationController
  before_filter :require_login, :except => [:menu]
  before_filter :require_admin, :except => [:menu, :frequencies, :update_frequencies]

  # GET /frequency_groups
  # GET /frequency_groups.xml
  def index
    @frequency_groups = FrequencyGroup.all.sort_by { |a| a.group_number.to_i } #group_number is a string
=begin
    #Mass Frequency Group Insert
    region = "R5"
    crew = 10
    (1..25).each do |num|
      group = region+" "+num.to_s.rjust(2, '0')
      r = FrequencyGroup.new({:name => "New Group", :dispatch_center_id => 1, :group_number => group, :crew_id => crew})
      r.save
      group_id = r.id

      (1..16).each do |chan|
        f = Frequency.new({:frequency_group_id => group_id, :channel => chan, :name => "CH"+chan.to_s, :band => "N", :full_name => "Channel "+chan.to_s})
        f.save
      end
    end
=end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @frequency_groups }
    end
  end

  # GET /frequency_groups/1
  # GET /frequency_groups/1.xml
  def show
    @frequency_group = FrequencyGroup.find(params[:id])
    @crew = Crew.find(@frequency_group.crew_id)
    @dispatch_center = DispatchCenter.find(@frequency_group.dispatch_center_id)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @frequency_group }
    end
  end

  # GET /frequency_groups/new
  # GET /frequency_groups/new.xml
  def new
    @frequency_group = FrequencyGroup.new
    @dispatch_centers = DispatchCenter.all
    @crews = Crew.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @frequency_group }
    end
  end

  # GET /frequency_groups/1/edit
  def edit
    @frequency_group = FrequencyGroup.find(params[:id])
    @crews = Crew.find(:all, :order => :name)
    @dispatch_centers = DispatchCenter.find(:all, :order => :name)
  end

  # POST /frequency_groups
  # POST /frequency_groups.xml
  def create
    @frequency_group = FrequencyGroup.new(params[:frequency_group])

    respond_to do |format|
      if @frequency_group.save
        format.html { redirect_to(@frequency_group, :notice => 'Frequency group was successfully created.') }
        format.xml  { render :xml => @frequency_group, :status => :created, :location => @frequency_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @frequency_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /frequency_groups/1
  # PUT /frequency_groups/1.xml
  def update
    @frequency_group = FrequencyGroup.find(params[:id])

    respond_to do |format|
      if @frequency_group.update_attributes(params[:frequency_group])
        format.html { redirect_to(@frequency_group, :notice => 'Frequency group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @frequency_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_frequencies
    Frequency.update(params[:frequency].keys, params[:frequency].values)
    @frequency_group = FrequencyGroup.find(params[:id])
    if @frequency_group.update_attributes(params[:frequency_group])
      flash[:notice] = 'Frequency Group was successfully updated.'
    else
      flash[:notice] = 'There was a problem updating the Frequency Group'
    end
    redirect_to :action => "frequencies"
  end

  # DELETE /frequency_groups/1
  # DELETE /frequency_groups/1.xml
  def destroy
    @frequency_group = FrequencyGroup.find(params[:id])
    @frequency_group.destroy

    respond_to do |format|
      format.html { redirect_to(frequency_groups_url) }
      format.xml  { head :ok }
    end
  end

  def frequencies
    prawnto :prawn => {
      :page_size => PdfSpecs::PAGE_SIZE, # (Handy Dandy page size)
      :margin => PdfSpecs::PAGE_MARGIN # Top, Right, Bottom, Left
    }
    @frequency_group = FrequencyGroup.find(params[:id])
    @frequencies = Frequency.find_all_by_frequency_group_id(@frequency_group.id, :order => "channel ASC")
    @dispatch_centers = DispatchCenter.find(:all,:order => :name)

  end

  def test
    @frequency_group = FrequencyGroup.find(params[:id])
    @frequencies = Frequency.find_all_by_frequency_group_id(@frequency_group.id, :order => "channel ASC")
    @dispatch_centers = DispatchCenter.find(:all,:order => :name)

    respond_to do |format|
      format.html # test.html.erb
    end
    
  end

  def menu
    @frequency_groups = FrequencyGroup.all

    respond_to do |format|
      format.html # menu.html.erb
    end
  end
end
