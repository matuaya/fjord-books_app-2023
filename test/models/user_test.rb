# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'name_or_email should return email when name is nil' do
    alice = build(:user, name: '', email: 'alice@example.com', password: 'password')
    bob = build(:user, name: 'bob', email: 'bob@example.com', password: 'password')

    assert_equal('alice@example.com', alice.name_or_email)
    assert_equal('bob', bob.name_or_email)
  end
end
