class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :destroy]

  def index
    @reports = Report.order(created_at: :desc)
  end

  def show
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to reports_path, notice: "Le rapport a été créé avec succès."
    else
      flash.now[:alert] = "Erreur lors de la création du rapport."
      render :new
    end
  end

  def destroy
    if @report.destroy
      redirect_to reports_path, notice: "Le rapport a été supprimé avec succès."
    else
      redirect_to reports_path, alert: "Erreur lors de la suppression du rapport."
    end
  end

  def generate
    date = params[:start_date].to_date.beginning_of_day
    end_date = params[:end_date].to_date.end_of_day

    appointments = Appointment.where(date: start_date..end_date, user: current_user)

    report_text = "Relève du #{start_date.strftime("%d/%m/%Y")} au #{end_date.strftime("%d/%m/%Y")} :\n\n"

    if appointments.any?
      appointments.each do |appointment|
        report_text += "Nom du patient : #{appointment.patient.first_name} #{appointment.patient.last_name}\n"
        report_text += "Date : #{appointment.date.strftime("%d/%m à %Hh%M")}\n"
        report_text += "Raison du rendez-vous : #{appointment.reason || 'Non spécifiée'}\n"
        report_text += "Résumé : #{appointment.summary || 'Non spécifiée'}\n\n"
      end
    else
      report_text += "Aucun rendez-vous trouvé pour la période sélectionnée.\n"
    end


    render json: { text: report_text }
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:text, :start_date, :end_date)
  end
end
