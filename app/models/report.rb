class Report < ApplicationRecord
    attribute :start_date, :date
    attribute :end_date, :date
    attribute :text, :string

    validates :start_date, presence: true
    validates :end_date, presence: true
    validate :dates_are_valid

    def generate_report_text
      return nil unless start_date.present? && end_date.present?

      "Rapport généré pour la période du #{start_date.strftime('%d/%m/%Y')} au #{end_date.strftime('%d/%m/%Y')}."
    end

    private

    def dates_are_valid
      if start_date.present? && end_date.present? && start_date > end_date
        errors.add(:start_date, "ne peut pas être postérieure à la date de fin.")
      end
    end
  end
