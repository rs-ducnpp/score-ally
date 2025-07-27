class ChartsController < ApplicationController
  before_action :set_chart, only: [ :show, :edit, :update, :destroy ]
  before_action :set_room, only: [ :index, :new, :create, :complete_round ]

  # GET /rooms/:room_id/charts
  def index
    @charts = @room.charts.includes(:user, :rule).order(:round, :created_at)
    @rounds = @charts.group_by(&:round)
    @users_in_room = @room.charts.includes(:user).group(:user_id).sum(:point)
  end

  # GET /charts/1
  def show
  end

  # GET /rooms/:room_id/charts/new
  def new
    @chart = @room.charts.build
    setup_form_variables

    if @room.participants.empty?
      redirect_to @room, alert: "Please add participants to this room before recording points."
    end
  end

  # GET /charts/1/edit
  def edit
    @room = @chart.room
    setup_form_variables
  end

  # POST /rooms/:room_id/charts
  def create
    @chart = @room.charts.build(chart_params)

    if valid_participant?(@chart.user) && @chart.save
      redirect_to room_charts_path(@room), notice: "Point record was successfully created."
    else
      add_participant_error unless valid_participant?(@chart.user)
      setup_form_variables
      render :new, status: :unprocessable_entity
    end
  end

  # POST /rooms/:room_id/charts/complete_round
  def complete_round
    @current_round = next_round_number

    charts_data = params[:charts] || []

    if charts_data.empty?
      redirect_to room_charts_path(@room), alert: "No chart data provided."
      return
    end

    ActiveRecord::Base.transaction do
      charts_data.each do |chart_data|
        next if chart_data[:user_id].blank? || chart_data[:rule_id].blank?

        validate_participant_for_round!(chart_data[:user_id])

        @room.charts.create!(
          user_id: chart_data[:user_id],
          rule_id: chart_data[:rule_id],
          round: @current_round
        )
      end
    end

    redirect_to room_charts_path(@room), notice: "Round #{@current_round} completed successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to room_charts_path(@room), alert: "Error completing round: #{e.message}"
  end

  # PATCH/PUT /charts/1
  def update
    @room = @chart.room
    user_id = chart_params[:user_id]&.to_i

    if user_id && valid_participant_id?(user_id) && @chart.update(chart_params)
      redirect_to @chart, notice: "Chart was successfully updated."
    else
      add_participant_error unless valid_participant_id?(user_id)
      setup_form_variables
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /charts/1
  def destroy
    room = @chart.room
    @chart.destroy
    redirect_to room_charts_path(room), notice: "Chart record was successfully deleted."
  end

  private

  def set_chart
    @chart = Chart.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def chart_params
    params.require(:chart).permit(:round, :user_id, :rule_id)
  end

  def setup_form_variables
    @users = @room.participants
    @rules = @room.rules
    @current_round = next_round_number
  end

  def next_round_number
    (@room.charts.maximum(:round) || 0) + 1
  end

  def valid_participant?(user)
    user && @room.participants.include?(user)
  end

  def valid_participant_id?(user_id)
    user_id && @room.participants.pluck(:id).include?(user_id)
  end

  def add_participant_error
    @chart.errors.add(:user, "must be a participant in this room")
  end

  def validate_participant_for_round!(user_id)
    unless @room.participants.pluck(:id).include?(user_id.to_i)
      raise ActiveRecord::RecordInvalid.new(Chart.new), "User must be a participant in this room"
    end
  end
end
