# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  has_many :mentioned_relationships, inverse_of: :mentioning,
                                     foreign_key: :mentioning_id,
                                     class_name: 'Relationship',
                                     dependent: :destroy

  has_many :mentioned_reports, through: :mentioned_relationships, source: :mentioned, dependent: :destroy

  has_many :mentioning_relationships, inverse_of: :mentioned,
                                      foreign_key: :mentioned_id,
                                      class_name: 'Relationship',
                                      dependent: :destroy

  has_many :mentioning_reports, through: :mentioning_relationships, source: :mentioning, dependent: :destroy
end
