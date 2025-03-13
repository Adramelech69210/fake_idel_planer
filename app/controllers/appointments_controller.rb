class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:edit, :update, :destroy]

  def index
    if params[:display] == 'month'
      year = (params[:year].to_i if params[:year].to_i > 0) || Date.today.year
      month = (params[:month].to_i if (1..12).include?(params[:month].to_i)) || Date.today.month
      @current_month = Date.new(year, month, 1)
    end

    case params[:display]
    when 'month'
    when 'week'
      @appointments = Appointment.where(user: current_user, start_date: Date.today.beginning_of_week(:monday)..Date.today.end_of_week(:monday))
    when 'day'
      @day = Date.jd(params[:jd].to_i)
      @appointments = Appointment.where(user: current_user, start_date: @day.all_day)
    else
      @day = Date.today
      @appointments = Appointment.where(user: current_user, start_date: @day.all_day)
    end
  end



  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user
    if @appointment.save
      redirect_to appointments_path, notice: "Rendez-vous crée!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, notice: "Rendez-vous modifié!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path, notice: "Rendez-vous supprimé!"
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:start_date, :end_date, :reason, :patient_id, :user_id)
  end
end
