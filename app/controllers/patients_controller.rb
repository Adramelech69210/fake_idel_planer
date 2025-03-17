class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy, :upload_ordonnance, :destroy_ordonnance]


  def index
    @patients = Patient.all
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
    @past_appointments = @appointments.where('end_date < ?', Time.current).order(end_date: :desc)
    @notes = @patient.notes.order(created_at: :desc)
    @pathologies = @patient.pathologies
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.group_id = current_user.group_id
    if @patient.save
      if params[:patient][:ordonnances].present? && params[:patient][:ordonnances] != [""]
        @patient.ordonnances.attach(params[:patient][:ordonnances])
      end
      redirect_to @patient, notice: "Patient créé avec succès !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # def update
  #   if @patient.update(patient_params)
  #     redirect_to @patient, notice: "Le patient a été mis à jour avec succès.", status: :see_other
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  def update
    if @patient.update(patient_params)
      render json: { success: true }
    else
      render json: { success: false, errors: @patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy!
    redirect_to patients_url, notice: "Le patient a été détruit avec succès.", status: :see_other
  end

  def upload_ordonnance
    if params[:patient][:ordonnances].present? && params[:patient][:ordonnances] != [""]
      @patient.ordonnances.attach(params[:patient][:ordonnances])
      redirect_to edit_patient_path(@patient), notice: "Ordonnance(s) téléchargée(s) avec succès !"
    else
      redirect_to edit_patient_path(@patient), alert: "Aucune ordonnance à télécharger."
    end
  end

  def destroy_ordonnance
    ordonnance = @patient.ordonnances.find(params[:ordonnance_id])
    ordonnance.purge
    if request.referer&.include?("/edit")
      redirect_to edit_patient_path(@patient), notice: "Ordonnance supprimée avec succès."
    else
      redirect_to @patient, notice: "Ordonnance supprimée avec succès."
    end
  end


  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :address, :date_of_birth, :social_security_number, :mutual, :referring_doctor, :group_id, :latitude, :longitude, ordonnances: [])
  end
end
