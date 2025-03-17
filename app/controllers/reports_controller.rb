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

  def update
    @report = Report.find(params[:id])

    if @report.update(report_params)
      redirect_to report_path(@report), notice: "Le rapport a été mis à jour avec succès."
    else
      flash.now[:alert] = "Erreur lors de la mise à jour du rapport."
      render :show, status: :unprocessable_entity
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
    start_date = params[:start_date].to_date
    end_date = params[:end_date].to_date
    report_text = ReportGenerator.new(start_date, end_date, current_user).generate

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
