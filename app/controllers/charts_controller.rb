class ChartsController < ApplicationController
  before_action :set_chart, only: [ :show, :edit, :update, :destroy ]
  before_action :set_room, only: [ :index, :new, :create ]

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
    @users = User.all
    @rules = @room.rules
    @current_round = (@room.charts.maximum(:round) || 0) + 1
  end

  # GET /charts/1/edit
  def edit
    @room = @chart.room
    @users = User.all
    @rules = @room.rules
  end

  # POST /rooms/:room_id/charts
  def create
    @chart = @room.charts.build(chart_params)

    # Let the model handle point calculation
    if @chart.save
      redirect_to room_charts_path(@room), notice: "Point record was successfully created."
    else
      @users = User.all
      @rules = @room.rules
      @current_round = (@room.charts.maximum(:round) || 0) + 1
      render :new, status: :unprocessable_entity
    end
  end

  # POST /rooms/:room_id/charts/complete_round
  def complete_round
    @room = Room.find(params[:room_id])
    @current_round = (@room.charts.maximum(:round) || 0) + 1

    # Get the submitted chart data
    charts_data = params[:charts] || []

    ActiveRecord::Base.transaction do
      charts_data.each do |chart_data|
        next if chart_data[:user_id].blank? || chart_data[:rule_id].blank?

        chart = @room.charts.build(
          user_id: chart_data[:user_id],
          rule_id: chart_data[:rule_id],
          round: @current_round
        )
        chart.save! # This will trigger the automatic point calculation
      end
    end

    redirect_to room_charts_path(@room), notice: "Round #{@current_round} completed successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to room_charts_path(@room), alert: "Error completing round: #{e.message}"
  end

  # PATCH/PUT /charts/1
  def update
    if @chart.update(chart_params)
      redirect_to @chart, notice: "Chart was successfully updated."
    else
      @room = @chart.room
      @users = User.all
      @rules = @room.rules
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

  def calculate_points(rule_id, point_type)
    rule = Rule.find(rule_id)
    case rule.point_type
    when "score"
      rule.point
    when "penalty"
      -rule.point
    else
      0
    end
  end
end
