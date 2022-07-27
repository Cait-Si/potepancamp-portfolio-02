require 'rails_helper'

describe 'メッセージ管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'userA', email: 'usera@test.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'userB', email: 'userb@test.com') }
  let!(:post_a) { FactoryBot.create(:post, title: 'Aの募集', user: user_a) }
  let!(:post_b) { FactoryBot.create(:post, title: 'Bの募集', user: user_b) }
  let!(:message_a) { FactoryBot.create(:message, content: 'おはようございます', user: user_a, post: post_a) }
  let!(:message_b) { FactoryBot.create(:message, user: user_b, post: post_a) }

  before do
    visit root_path
    within all('.main_wrapper').last do
      click_link 'ログイン'
    end
    fill_in 'Eメール', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
    visit post_path(post_a)
  end

  describe 'メッセージ表示機能' do
    let(:login_user) { user_a }

    context '作成済みのメッセージの表示' do
      it 'チャット内に表示される' do
        expect(page).to have_selector '.message_created', text: message_a.user.name
        expect(page).to have_selector '.user_message', text: 'おはようございます'
        expect(page).to have_selector '.message_info', text: message_a.created_at.to_s(:datetime_jp)
        expect(page).to have_selector '.message_created', text: message_b.user.name
        expect(page).to have_selector '.user_message', text: 'こんにちは'
        expect(page).to have_selector '.message_info', text: message_b.created_at.to_s(:datetime_jp)
      end
    end
  end

  describe 'メッセージ作成機能' do
    before do
      fill_in 'メッセージを入力(Shift+Enterで送信します)', with: message
      find('.room_message_form_textarea').send_keys(:shift, :enter)
    end

    context '新規メッセージ作成' do
      let(:login_user) { user_a }
      let(:message) { '新規メッセージ_A' }

      it 'チャット内の右側側に表示される' do
        expect(page).to have_selector '.user_message', text: '新規メッセージ_A'
      end
    end
  end
end
