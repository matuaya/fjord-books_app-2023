# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    user = create(:user)
    @report = create(:report, user:)

    visit root_url
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in '内容', with: @report.content
    fill_in 'タイトル', with: @report.title
    click_button '登録する'

    assert_text '日報が作成されました。'
    assert_text 'Railsについて' 
    assert_text '興味深い'
    click_link '日報の一覧に戻る'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in '内容', with: '内容を変更する。'
    fill_in 'タイトル', with: 'タイトルも変更する。'
    click_button '更新する'

    assert_text '日報が更新されました。'
    assert_text '内容を変更する。'
    assert_text'タイトルも変更する。'
    click_link '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first
    assert_no_text '内容を変更する。'
    assert_no_text 'タイトルも変更する。'

    assert_text '日報が削除されました。'
  end
end
