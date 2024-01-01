# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'Railsについて' }
    content { '興味深い' }
    user { FactoryBot.create(:user) }
  end
end
