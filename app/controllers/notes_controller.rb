class NotesController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def index        
    @@note = Note.all
  end

  def new
    @note = Note.new
  end
  def show
    @note = @patient.notes.find(params[:id])
  end

  def create                                #/patients/:patient_id/notes(.:format)
    @note = @patient.notes.new(note_params)
    if @note.save
      redirect_to @patient, notice: 'Note was successfully created.'
    else
      render 'patients/show', status: :unprocessable_entity
    end
  end

  def destroy
    @note = @patient.notes.find(params[:id])
    @note.destroy
    redirect_to @patient, notice: 'Note was successfully destroyed.'
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def note_params
    params.require(:note).permit(:text)
  end

end
