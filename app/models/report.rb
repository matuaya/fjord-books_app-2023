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

  def save_with_mention!
    ActiveRecord::Base.transaction do
      save!
      create_mention_relationships!
    end
  end

  def create_mention_relationships!
    mentioning_ids = get_ids_from_urls

    mentioning_ids.each do |mentioning_id|
      mentioning_report = Report.find(mentioning_id)
      Relationship.create!(mentioning_id: mentioning_report.id, mentioned_id: id)
    end
  end

  def update_with_mention!(report_params)
    ActiveRecord::Base.transaction do
      update!(report_params)
      update_mention_relationships!
    end
  end

  def update_mention_relationships!
    original_mentioning_report_ids = mentioning_reports.pluck(:id)
    updated_mentioning_report_ids = get_ids_from_urls

    updated_mentioning_report_ids.each do |mentioning_id|
      mentioning_report = Report.find(mentioning_id)
      Relationship.create!(mentioning_id: mentioning_report.id, mentioned_id: id) unless original_mentioning_report_ids.include?(mentioning_id)
    end

    deleted_mentions = original_mentioning_report_ids - updated_mentioning_report_ids

    deleted_mentions.each do |mention|
      relationship = Relationship.find_by(mentioning_id: mention, mentioned_id: id)
      relationship&.destroy
    end
  end

  def get_ids_from_urls
    content.scan(%r{localhost:3000/reports/(\d+)}).uniq.flatten.map(&:to_i)
  end

  has_many :mentioned_relationships, inverse_of: :mentioning,
                                     foreign_key: :mentioning_id,
                                     class_name: 'Relationship',
                                     dependent: :destroy

  has_many :mentioned_reports, through: :mentioned_relationships, source: :mentioned

  has_many :mentioning_relationships, inverse_of: :mentioned,
                                      foreign_key: :mentioned_id,
                                      class_name: 'Relationship',
                                      dependent: :destroy

  has_many :mentioning_reports, through: :mentioning_relationships, source: :mentioning
end
