require 'rails_helper'

describe 'マイページ機能' , type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'userA', email: 'usera@test.com', introduction: 'hello', profile_photo: File.open("app/assets/images/default_profile_photo.png")) }
  let(:user_b) { FactoryBot.create(:user, name: 'userB', email: 'userb@test.com', introduction: 'good morning', profile_photo: File.open("app/assets/images/top_person.png")) }
  let!(:post_a) { FactoryBot.create(:post, title: 'Aの募集', user: user_a) }
  let!(:post_b) { FactoryBot.create(:post, title: 'Bの募集', user: user_b) }

  before do
    visit root_path
    within all('.main_wrapper').last do
      click_link 'ログイン'
    end
    fill_in 'Eメール', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  describe 'マイページ表示機能' do
    context 'userAがログインしているとき' do
      let(:login_user) { user_a }

      it 'userAのプロフィールと作成した募集一覧が表示される' do
        within '.header_link' do
          click_link 'マイページ'
        end
        expect(page).to have_content 'userA'
        expect(page).to have_content 'hello'
        expect(page).to have_selector ("img[src$='default_profile_photo.png']")
        expect(page).to have_content 'Aの募集'
        expect(page).to have_no_content 'Bの募集'
      end

      it 'ログインユーザー以外のプロフィール表示' do
        within '.header_link' do
          click_link '募集一覧'
        end
        click_link 'userB'

        expect(page).to have_content 'userB'
        expect(page).to have_content 'good morning'
        expect(page).to have_selector ("img[src$='top_person.png']")
        expect(page).to have_content 'Bの募集'
        expect(page).to have_no_content 'Aの募集'
      end
    end
  end

  describe 'マイページ編集機能' do
    let(:login_user) { user_a }

    before do
      within '.header_link' do
        click_link 'マイページ'
      end
      click_link '編集する'
      fill_in '名前', with: user_name
      fill_in 'Eメール', with: user_email
      fill_in '自己紹介', with: user_introduction
      if user_profile
        attach_file(user_profile)
      end
      fill_in 'パスワード', with: user_password
      fill_in 'パスワード（確認用）', with: user_password_confirmation
      fill_in '現在のパスワード', with: user_current_password
      within '.devise_form_submit' do
        click_button '更新'
      end
    end

    context '正しく入力した場合' do
      let(:user_name) { 'userA_edit' }
      let(:user_email) { 'usera_edit@test.com' }
      let(:user_introduction) { 'edit test' }
      let(:user_profile) { 'app/assets/images/top_person.png' }
      let(:user_password) { '123456' }
      let(:user_password_confirmation) { '123456' }
      let(:user_current_password) { '123123' }

      it '正常に更新されマイページが表示される' do
        expect(page).to have_content 'userA_edit'
        expect(page).to have_content 'edit test'
        expect(page).to have_selector ("img[src$='top_person.png']")
      end
    end
  end
end
