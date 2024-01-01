# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'editable? should return true when current user and false when otherwise' do
    current_user = create(:user)
    another_user = create(:user, name: 'bob')
    current_user_report = build(:report, user: current_user)

    assert current_user_report.editable?(current_user)
    assert_not current_user_report.editable?(another_user)
  end

  test 'create_on should return formatted date' do
    report = create(:report)

    assert_equal(Time.zone.today, report.created_on)
  end

  test 'mentions should not be created under certain conditions' do
    bob_report = create(:report)
    charlie_report = create(:report)
    alice_report = create(:report, content: "http://localhost:3000/reports/#{bob_report.id}の日報と、" \
                                            "http://localhost:3000/reports/#{bob_report.id}の日報と、" \
                                            "http://localhost:3000/reports/#{charlie_report.id}の日報と、" \
                                            "http://localhost/reports/#{charlie_report.id}の日報と、" \
                                            'http://localhost:3000/reports/1の日報')

    alice_report_mentioning_ids = alice_report.mentioning_reports.map(&:id).sort

    # 重複しているidは一意にし、レポートが存在しない場合やマッチしないURLの場合はメンションを作らない
    assert_equal([bob_report.id, charlie_report.id].sort, alice_report_mentioning_ids)
  end

  test 'mentions should be removed if associated reports deleted during update' do
    bob_report = create(:report)
    charlie_report = create(:report)
    dave_report = create(:report)
    alice_report = create(:report, content: "http://localhost:3000/reports/#{bob_report.id}の日報と、" \
                                            "http://localhost:3000/reports/#{charlie_report.id}の日報")

    alice_report.update!(content: "http://localhost:3000/reports/#{charlie_report.id}の日報と、"\
                                  "http://localhost:3000/reports/#{dave_report.id}の日報")
    alice_report.mentioning_reports.reload

    alice_reports_mentioning_ids = alice_report.mentioning_reports.map(&:id)

    # 削除されたレポートのメンションは削除され、新たに追加されたレポートは新たにメンションを作成する
    assert_equal([charlie_report.id, dave_report.id], alice_reports_mentioning_ids)
  end

  test 'metions should be removed when report is deleted' do
    bob_report = create(:report)
    alice_report = create(:report, content: "http://localhost:3000/reports/#{bob_report.id}の日報")
    alice_report.destroy!
    assert_equal([], bob_report.mentioned_reports)
  end
end
