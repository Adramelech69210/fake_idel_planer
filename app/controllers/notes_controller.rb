class NotesController < ApplicationController
  before_action :set_patient
  before_action :set_note, only: [:show, :edit, :update, :destroy]


  def index
    @notes = @patient.notes
  end

  def new
    @note = @patient.notes.build
  end

  def create
    @note = @patient.notes.build(note_params)
    if @note.save
      redirect_to patient_notes_path(@patient), notice: 'Note créée avec succès.'
    else
      render :new
    end
  end

  def show
  end

  def edit

  end

  def update
    if @note.update(note_params)
      redirect_to patient_notes_path(@patient), notice: 'Note mise à jour avec succès.'
    else
      render :edit
    end
  end

  def destroy
    @note.destroy!
    redirect_to patient_notes_path(@patient), notice: 'Note supprimée avec succès.'
  end


  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_note
    @note = @patient.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:text)
  end
end
