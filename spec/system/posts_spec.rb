require 'rails_helper'

describe '募集管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'userA', email: 'usera@test.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'userB', email: 'userb@test.com') }
  let!(:post_a) { FactoryBot.create(:post, title: 'Aの募集', user: user_a) }
  let!(:post_b) { FactoryBot.create(:post, title: 'Bの募集', user: user_b) }
  let!(:post_yesterday) { FactoryBot.create(:post, :skip_validation, title: '日時が昨日の募集', datetime: Time.now.yesterday, end_datetime: Time.now.yesterday + 2.hours, user: user_a) }

  before do
    visit root_path
    within all('.main_wrapper').last do
      click_link 'ログイン'
    end
    fill_in 'Eメール', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
    within '.header_link' do
      click_link '募集一覧'
    end
  end

  describe '一覧表示機能' do
    context 'userAがログインしているとき' do
      let(:login_user) { user_a }

      it '作成した募集が表示される' do
        expect(page).to have_content 'Aの募集'
        expect(page).to have_content 'Bの募集'
        expect(page).to have_selector ("img[src$='top_person.png']")
      end

      it '日時が過ぎた募集が表示されない' do
        expect(page).to have_no_content '日時が昨日の募集'
      end
    end
  end

  describe '詳細機能' do
    before do
      visit post_path(post_a)
      if finished
        click_link '募集終了にする'
      end
    end

    context 'userAがログインし、募集中の場合' do
      let(:login_user) { user_a }
      let(:finished) { false }

      it 'userAが作成した募集が表示される' do
        expect(page).to have_content 'Aの募集'
        expect(page).to have_content '1'
        expect(page).to have_content '初心者歓迎'
        expect(page).to have_content (Time.now.tomorrow).to_s(:datetime_jp)
        expect(page).to have_content (Time.now.tomorrow + 2.hours).to_s(:datetime_jp)
        expect(page).to have_content '東京都新宿区1-1-1'
        expect(page).to have_content 'test_discription'
        expect(page).to have_content Time.now.to_s(:datetime_jp)
        expect(page).to have_selector ("img[src$='top_person.png']")
      end

      it 'ログイン者と募集作成者が同じ場合' do
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
        expect(page).to have_content '募集終了にする'
      end
    end

    context 'userAがログインし、募集終了の場合' do
      let(:login_user) { user_a }
      let(:finished) { true }

      it 'userAが作成した募集が表示される' do
        expect(page).to have_content 'Aの募集'
        expect(page).to have_content '1'
        expect(page).to have_content '初心者歓迎'
        expect(page).to have_content (Time.now.tomorrow).to_s(:datetime_jp)
        expect(page).to have_content (Time.now.tomorrow + 2.hours).to_s(:datetime_jp)
        expect(page).to have_content '東京都新宿区1-1-1'
        expect(page).to have_content 'test_discription'
        expect(page).to have_content Time.now.to_s(:datetime_jp)
        expect(page).to have_selector ("img[src$='top_person.png']")
        expect(page).to have_selector '.finished_mark', text: '募集終了'
      end

      it 'ログイン者と募集作成者が同じ場合' do
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
        expect(page).to have_content '募集中に戻す'
      end
    end

    context 'userBがログインしているとき' do
      let(:login_user) { user_b }
      let(:finished) { false }

      it 'ログイン者と募集作成者が異なる場合' do
        expect(page).to have_no_content '編集'
        expect(page).to have_no_content '削除'
        expect(page).to have_no_content '募集終了にする'
        expect(page).to have_no_content '募集中に戻す'
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      within '.header_link' do
        click_link '募集作成'
      end
      fill_in '題名', with: post_title
      fill_in '人数', with: post_person
      if post_level
        choose post_level
      end
      fill_in '開始日時', with: post_datetime
      fill_in '終了日時', with: post_end_datetime
      fill_in '場所', with: post_address
      fill_in '説明', with: post_discription
      if post_image
        attach_file(post_image)
      end
      fill_in '締切', with: post_deadline
      within '.form_submit' do
        click_button '登録'
      end
    end

    context '新規募集作成に全て入力したとき' do
      let(:post_title) { '新規募集' }
      let(:post_person) { 2 }
      let(:post_level) { '経験者以上' }
      let(:post_datetime) { Time.now + 2.days }
      let(:post_end_datetime) { Time.now + 2.days + 2.hours }
      let(:post_address) { '東京都千代田区1-1-1' }
      let(:post_discription) { '新規募集説明' }
      let(:post_deadline) { Time.now.tomorrow }
      let(:post_image) { "app/assets/images/chat_demo.png" }

      it '正常に登録され一覧に表示される' do
        expect(page).to have_content '新規募集'
        expect(page).to have_content '2'
        expect(page).to have_content '経験者以上'
        expect(page).to have_content (Time.now + 2.days).to_s(:datetime_jp)
        expect(page).to have_content '東京都千代田区1-1-1'
        expect(page).to have_content (Time.now.tomorrow).to_s(:datetime_jp)
        expect(page).to have_selector ("img[src$='chat_demo.png'")
      end
    end

    context '入力フォームに未入力があったとき' do
      let(:post_title) { '' }
      let(:post_person) {  }
      let(:post_level) { nil }
      let(:post_datetime) {  }
      let(:post_end_datetime) {  }
      let(:post_address) { '' }
      let(:post_discription) { '' }
      let(:post_deadline) {  }
      let(:post_image) { nil }

      it 'エラーとなりその項目を入力してくださいと表示される' do
        expect(page).to have_content '題名を入力してください'
        expect(page).to have_content '人数を入力してください'
        expect(page).to have_content '対象を入力してください'
        expect(page).to have_content '開始日時を入力してください'
        expect(page).to have_content '終了日時を入力してください'
        expect(page).to have_content '場所を入力してください'
        expect(page).to have_content '説明を入力してください'
        expect(page).to have_content '画像を入力してください'
        expect(page).to have_content '締切を入力してください'
      end
    end

    context '日時が締切より前の日付のとき' do
      let(:post_title) { '新規募集' }
      let(:post_person) { 2 }
      let(:post_level) { '経験者以上' }
      let(:post_datetime) { Time.now }
      let(:post_end_datetime) {Time.now + 2.hours }
      let(:post_address) { '東京都千代田区1-1-1' }
      let(:post_discription) { '新規募集説明' }
      let(:post_deadline) { Time.now.tomorrow }
      let(:post_image) { "app/assets/images/chat_demo.png" }

      it 'エラーとなり締切は開始日前のものを選択してくださいと表示される' do
        expect(page).to have_content '締切は開始日時前のものを選択してください'
      end
    end

    context '日時が今日より前の日付のとき' do
      let(:post_title) { '新規募集' }
      let(:post_person) { 2 }
      let(:post_level) { '経験者以上' }
      let(:post_datetime) { Time.now.yesterday }
      let(:post_end_datetime) { Time.now.yesterday + 2.hours }
      let(:post_address) { '東京都千代田区1-1-1' }
      let(:post_discription) { '新規募集説明' }
      let(:post_deadline) { Time.now - 2.days }
      let(:post_image) { "app/assets/images/chat_demo.png" }

      it 'エラーとなり日時は今日以降のものを選択してくださいと表示される' do
        expect(page).to have_content '日時は今日以降のものを選択してください'
      end
    end
  end

  describe '募集編集機能' do
    let(:login_user) { user_a }

    before do
      visit post_path(post_a)
      within '.edit_delete_wrapper' do
        click_link '編集'
      end
      fill_in '題名', with: '編集した募集'
      fill_in '人数', with: 4
      choose '初心者歓迎'
      fill_in '場所', with: '埼玉県越谷市'
      fill_in '説明', with: '編集した募集説明'
      within '.form_submit' do
        click_button '登録'
      end
    end

    context '募集を編集したとき' do
      it '正常に編集され一覧に表示される' do
        expect(page).to have_content '編集した募集'
        expect(page).to have_content '4'
        expect(page).to have_content '初心者歓迎'
        expect(page).to have_content '埼玉県越谷市'
      end
    end
  end

  describe '募集削除機能' do
    let(:login_user) { user_a }

    before do
      visit post_path(post_a)
      within '.edit_delete_wrapper' do
        click_link '削除'
      end
    end

    context '正常に削除される' do
      it '募集一覧からAの募集が削除されて表示される' do
        expect(page).to have_no_content 'Aの募集'
        expect(page).to have_content 'Bの募集'
      end
    end
  end
end
