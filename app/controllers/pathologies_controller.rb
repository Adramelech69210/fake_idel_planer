class PathologiesController < ApplicationController
  before_action :set_patient
  before_action :set_pathology, only: [:show, :edit, :update, :destroy]


  def index
    @pathologies = @patient.pathologies
  end

  def new
    @pathology = @patient.pathologies.new
  end

  def create
    @pathology = @patient.pathologies.new(pathology_params)
    if @pathology.save
      redirect_to patient_path(@patient), notice: 'Pathologie créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @pathology.update(pathology_params)
      redirect_to patient_path(@patient), notice: 'Pathologie mise à jour avec succès.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @pathology.destroy!
    redirect_to patient_path(@patient), notice: 'Pathologie supprimée avec succès.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_pathology
    @pathology = Pathology.find(params[:id])
  end

  def pathology_params
    params.require(:pathology).permit(:description)
  end
end
