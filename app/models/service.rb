class Service < ApplicationRecord
  belongs_to :organisation

  has_one :contact
  has_many :service_at_locations
  has_many :locations, through: :service_at_locations

  has_many :service_taxonomies
  has_many :taxonomies, through: :service_taxonomies

  # watch functionality
  has_many :watches
  has_many :users, through: :watches

  has_many :notes

  after_save :update_service_at_locations

  accepts_nested_attributes_for :locations

  # sort scopes
  scope :oldest, ->  { order("updated_at ASC") }
  scope :newest, ->  { order("updated_at DESC") }
  scope :alphabetical, ->  { order("name ASC") }
  scope :reverse_alphabetical, ->  { order("name DESC") }

  # filter scopes
  scope :in_taxonomy, -> (id) { joins(:taxonomies).where("taxonomies.id in (?)", id)}

  paginates_per 20
  validates_presence_of :name


  audited  associated_with: [:taxonomy, :service_taxonomy]

  has_paper_trail ignore: [:created_at, :updated_at, :discarded_at, :approved]

  include Discard::Model

  include PgSearch::Model
  pg_search_scope :search, 
    against: [:name, :description], 
    using: {
      tsearch: { prefix: true }
    }

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

  def display_name
    self.name || "Unnamed service"
  end

  def status
    if discarded?
      "archived"
    elsif !approved
      "pending"
    else
      "active"
    end
  end

  # custom actions with paper trail events
  def archive
    self.paper_trail_event = 'archive'
    self.discard
    self.paper_trail.save_with_version
  end

  def restore
    self.paper_trail_event = 'restore'
    self.undiscard
    self.paper_trail.save_with_version
  end

  def approve
    self.paper_trail_event = 'approve'
    self.approved = true
    self.save
    self.paper_trail.save_with_version
  end

  def update_service_at_locations
    self.service_at_locations.each do |service_at_location|
      service_at_location.update_service_fields
    end
  end

end