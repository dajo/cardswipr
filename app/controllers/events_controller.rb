require "yaleidlookup"

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  # GET /events/1/swipe
  def swipe
    # authorize! :read, :cardswipe
    @event = Event.find(params[:event_id])
    @count = @event.attendance_entries.count
  end


  # POST /events/1/lookup
  def lookup
    # authorize! :lookup, :cardswipe
    binding.pry
    @event = Event.find(params[:event_id])
    attributes = YaleIDLookup.lookup(params[:query])

    if attributes.empty? #or, if it raises an "I cannot find someone" error would be better?
      flash.now[:error] = "I'm sorry, Dave, I didn't find anyone"
      redirect_to event_swipe_path(@event)
    end

    attributes[:event] = @event
    attendanceentry = AttendanceEntry.new(attributes)

    if attendanceentry.save
      flash[:notice] = "#{attendanceentry.name} has been successfully recorded for this event."
      @count = Student.count
    else
      flash[:error] = "Unexpected error while trying to record this person."
    end

    # if person.recorded?
    #   flash[:error] = "#{person.name} has already been recorded for this event."
    #   redirect_to :distribution_index and return
    # end

    # if person.record
    #   flash[:notice] = "#{person.name} has been successfully recorded for this event."
    #   @count = Student.count
    # else
    #   flash[:error] = "Unexpected error while trying to record this person."
    # end

    redirect_to event_swipe_path(@event)

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description)
    end
end