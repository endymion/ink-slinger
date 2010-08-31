class TopicsController < ApplicationController
  layout 'editor'

  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.order('topics.updated_at DESC').paginate :page => params[:page], :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  before_filter :clone_image_attachment, :only => [:create, :update]
  def clone_image_attachment
    params['topic']['images_attributes']['1'] = params['topic']['images_attributes']['0'].clone
    params['topic']['images_attributes']['1']['tile_256'] = params['topic']['images_attributes']['1']['tile_512']
    params['topic']['images_attributes']['1'].delete 'tile_512'
  end
  after_filter :prune_duplicate_image, :only => [:create, :update]
  def prune_duplicate_image
    # Discard the tile_512 image if it's not any larger than the tile_256 image.
    for image in @topic.images
      if Paperclip::Geometry.from_file(image.tile_512.to_file(:original)).width <= 512
        image.tile_512 = nil
        image.save
      end
    end
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      if @topic.save
        format.html { redirect_to(@topic, :notice => 'Topic was successfully created.') }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to(@topic, :notice => 'Topic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
end
