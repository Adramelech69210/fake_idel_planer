class NotesController < ApplicationController

  def show
    @note = @patient.notes.find(params[:id])
  end

  def create
    @note = @patient.notes.new(note_params)     #patients/:patient_id/notes/new(.:format)
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
