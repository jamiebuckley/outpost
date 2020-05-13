class Feedback < ApplicationRecord
  belongs_to :service

  validates_presence_of :topic
  validates_presence_of :body  
end