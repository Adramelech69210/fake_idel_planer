class PathologiesController < ApplicationController
before_action :set_patient
before_action :set_pathology, only: [:show, :edit, :update, :destroy]

def index
  @pathologies = @patient.pathologies
end

def new
  @note = @patient.pathologies.build
end

def create
  @note = @patient.pathologies.build(note_params)
  if @note.save
    redirect_to patient_pathologies_path(@patient), notice: 'Note créée avec succès.'
  else
    render :new
  end
end

def update
  if @note.update(pathology_params)
    redirect_to patient_pathologies_path(@patient), notice: 'Note mise à jour avec succès.'
  else
    puts @note.errors.full_messages
    render :edit
  end
end






  def show
    @pathology = @patient.pathologies.find(params[:id])
  end
  def create
    @pathology = @patient.pathologies.new(pathology_params)
    if @pathology.save
      redirect_to @patient, notice: 'Pathology was successfully created.'
    else
      render 'patients/show', status: :unprocessable_entity
    end
  end

  def destroy
    @pathology = @patient.pathologies.find(params[:id])
    @pathology.destroy
    redirect_to @patient, notice: 'Pathology was successfully destroyed.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def pathology_params
    params.require(:pathology).permit(:description)
  end
