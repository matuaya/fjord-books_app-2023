# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report'
  belongs_to :mentioned, class_name: 'Report'
end
