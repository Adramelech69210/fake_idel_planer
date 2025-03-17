class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy, :upload_ordonnance, :destroy_ordonnance]

  def index
    @patients = Patient.all
    if params[:query].present?
      @patients = @patients.where("first_name ILIKE :query OR last_name ILIKE :query", query: "%#{params[:query]}%")
    end
  end




  def new
    @patient = Patient.new
  end


  def show
    if @patient.geocoded? # Vérifie si le patient est géocodé
      @marker = {
        lat: @patient.latitude,
        lng: @patient.longitude,
        info_marker_html: render_to_string(partial: "info_marker_patient", locals: { patient: @patient }),
        marker_html: render_to_string(partial: "marker")
      }
    else
      @marker = nil # Si le patient n'est pas géocodé, pas de marqueur
    end
    @appointments = @patient.appointments
    @past_appointments = @appointments.where('start_date < ?', Time.current).order(start_date: :desc)
    @upcoming_appointments = @appointments.where("start_date >= ?", Time.current).order(start_date: :asc)
    @notes = @patient.notes.order(created_at: :desc)
    @pathologies = @patient.pathologies
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to @patient, notice: "Patient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: "Patient was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy!
    redirect_to patients_url, notice: "Patient was successfully destroyed.", status: :see_other
  end

  def upload_ordonnance
    if params[:patient].present? && params[:patient][:ordonnances].present? && params[:patient][:ordonnances]!=[""]
      @patient.ordonnances.attach(params[:patient][:ordonnances])
      redirect_to @patient, notice: "Ordonnance(s) uploadée(s) avec succès !"
    else
      redirect_to @patient, alert: "Aucune ordonnance à uploader."
    end
  end







  def destroy_ordonnance
    ordonnance = @patient.ordonnances.find(params[:ordonnance_id])
    ordonnance.purge
    redirect_to @patient, notice: "Ordonnance supprimée avec succès."
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :address, :date_of_birth, :social_security_number, :mutual, :referring_doctor, ordonnances: [])
  end
end
