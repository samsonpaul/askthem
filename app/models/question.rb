class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in session: 'default' # @see https://github.com/mongoid/mongoid/pull/2909

  # The author of the question.
  belongs_to :user
  # The signatures in support of the question.
  has_many :signatures

  # The jurisdiction in which the question is asked.
  field :state, type: String
  # The person to whom the question is addressed.
  field :person_id, type: String
  # The bill the question is about.
  field :bill_id, type: String
  # The question's summary.
  field :title, type: String
  # The question's content.
  field :body, type: String
  # The question's issue area.
  field :subject, type: String
  # The number of signatures.
  field :signature_count, type: Integer, default: 0
  # Whether the question is answered.
  # @note Use `update_attribute`, not `set`, to trigger the observers.
  field :answered, type: Boolean, default: false

  index(state: 1)
  index(person_id: 1, answered: 1)
  index(bill_id: 1, answered: 1)

  validates_presence_of :state, :person_id, :user_id, :title, :body
  validates_length_of :title, within: 3..60, allow_blank: true
  validates_length_of :body, minimum: 60, allow_blank: true
  validate :state_must_be_included_in_the_list_of_states
  validate :subject_must_be_included_in_the_list_of_subjects
  validate :question_and_person_must_belong_to_the_same_jurisdiction
  validate :person_and_bill_must_belong_to_the_same_jurisdiction

  attr_accessor :person_state, :bill_state

  # @return [Metadatum] the jurisdiction in which the question is asked
  def metadatum
    Metadatum.find_by_abbreviation(state)
  end

  # @return [Person] the person to whom the question is addressed
  def person
    Person.use(state).find(person_id)
  end

  # @param [Person] person a person
  def person=(person)
    if person
      self.person_id = person.id
      self.person_state = person['state']
      self.state ||= person['state']
    else
      self.person_id = nil
    end
  end

  # @return [Bill] the bill the question is about
  def bill
    Bill.use(state).find(bill_id)
  end

  # @param [Bill] bill a bill
  def bill=(bill)
    if bill
      self.bill_id = bill.id
      self.bill_state = bill['state']
      self.state ||= bill['state']
    else
      self.bill_id = nil
    end
  end

private
  def state_must_be_included_in_the_list_of_states
    unless state.blank? || Metadatum.find_by_abbreviation(state)
      errors.add(:state, 'is not included in the list of states')
    end
  end

  def subject_must_be_included_in_the_list_of_subjects
    unless subject.blank? || Bill.in(state).distinct('subjects').include?(subject)
      errors.add(:subject, 'is not included in the list of subjects')
    end
  end

  def question_and_person_must_belong_to_the_same_jurisdiction
    unless person_state.blank? || person_state == state
      errors.add(:base, 'The question and the person must belong to the same state')
    end
  end

  def person_and_bill_must_belong_to_the_same_jurisdiction
    unless bill_state.blank? || bill_state == person_state
      errors.add(:base, 'The person and the bill must belong to the same state')
    end
  end
end
