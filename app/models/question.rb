class Question < ApplicationRecord
  belongs_to :subject, counter_cache: true, inverse_of: :questions
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  scope :search, -> (term, page) {
    Question.includes(:answers)
            .where("description ILIKE ?", "%#{term}%")
            .page(page)
            .per(5)
  }

  scope :search_subject, -> (subject_id, page) {
    Question.includes(:answers, :subject)
            .where(subject_id: subject_id)
            .page(page)
            .per(5)
  }

  scope :last_questions, -> (page) {
    Question.includes(:answers)
            .order('created_at desc')
            .page(page)
            .per(5)
  }

end
