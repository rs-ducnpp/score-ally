class RoomsController < ApplicationController
  before_action :set_room, only: [ :show, :edit, :update, :destroy ]

  # GET /rooms
  def index
    @rooms = Room.includes(:user).all
  end

  # GET /rooms/1
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @users = User.all
  end

  # GET /rooms/1/edit
  def edit
    @users = User.all
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      # Add selected users as participants
      if params[:room][:participant_ids].present?
        participant_ids = params[:room][:participant_ids].reject(&:blank?)
        participant_ids.each do |user_id|
          @room.room_users.create(user_id: user_id)
        end
      end

      redirect_to @room, notice: "Room was successfully created."
    else
      @users = User.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      # Update participants
      if params[:room][:participant_ids].present?
        @room.room_users.destroy_all
        participant_ids = params[:room][:participant_ids].reject(&:blank?)
        participant_ids.each do |user_id|
          @room.room_users.create(user_id: user_id)
        end
      else
        @room.room_users.destroy_all
      end

      redirect_to @room, notice: "Room was successfully updated."
    else
      @users = User.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy
    redirect_to rooms_url, notice: "Room was successfully deleted."
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :show_total_point, :room_type, :limit_point, :limit_round, :user_id)
  end
end
