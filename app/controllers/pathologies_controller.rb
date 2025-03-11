class PathologiesController < ApplicationController
before_action :set_patient

  def show
    @pathologies = @patient.pathologies.find(params[:id])
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
