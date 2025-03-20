class ReportGenerator
  def initialize(start_date, end_date, user)
    @start_date = start_date.beginning_of_day
    @end_date = end_date.end_of_day
    @user = user
  end

  def generate
    appointments = Appointment.where(date: @start_date..@end_date, user: @user)

    report_text = "<p>Relève du #{@start_date.strftime('%d/%m/%Y')} au #{@end_date.strftime('%d/%m/%Y')}</p>\n\n"

    if appointments.any?
      appointments.each do |appointment|
        report_text += format_appointment(appointment)
      end
    else
      report_text += "Aucun rendez-vous trouvé pour la période sélectionnée.\n"
    end

    report_text
  end

  private

  def format_appointment(appointment)
    <<~TEXT
      <div class="special_text">
      <strong>Nom du patient</strong>
      <p>#{appointment.patient.name}</p>
      <strong>Date</strong>
      <p>#{appointment.date.strftime("%d/%m")} à #{appointment.start_time.strftime("%Hh%M")}</p>
      <strong>Raison du rendez-vous</strong>
      <p>#{appointment.reason || 'Non spécifiée'}</p>
      <strong>Résumé</strong>
      <p>#{appointment.summary || 'Non spécifiée'}</p>
      <div class="line-continuous"></div>
      </div>
      
    TEXT
  end
end
