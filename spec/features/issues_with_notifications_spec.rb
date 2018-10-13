require 'spec_helper'

describe 'Issue notifications' do
  include_context 'signed in as a site user'

  let(:issue_values) { attributes_for(:issue_with_json_loc) }

  context 'on a new issue' do

    def fill_in_issue
      visit new_issue_path
      fill_in 'Title', with: issue_values[:title]
      fill_in 'Write a description', with: issue_values[:description]
      find('#issue_loc_json', visible: false).set(issue_values[:loc_json])
    end

    describe 'for users with overlapping user locations' do
      let(:user) { create(:user) }
      let!(:user_location) { create(:user_location, user: user, loc_json: issue_values[:loc_json]) }

      before do
        user.prefs.update_column(:involve_my_locations, 'notify')
        user.prefs.update_column(:email_status_id, 1)
      end

      it 'should send a notification' do
        fill_in_issue
        click_on 'Send Report'
        expect(page).to have_content(issue_values[:title])
        email = open_last_email_for(user_location.user.email)
        expect(email).to have_subject("[Cyclescape] New issue - \"#{issue_values[:title]}\"")
        expect(email).to have_body_text(issue_values[:title])
        expect(email).to have_body_text(issue_values[:description])
        expect(email).to have_body_text(current_user.name)
      end

      it 'should not include html entities in the message' do
        fill_in_issue
        fill_in 'Title', with: 'Test containing A & B'
        fill_in 'Write a description', with: 'Something & something else'
        click_on 'Send Report'
        email = open_last_email_for(user_location.user.email)
        expect(email).not_to have_body_text('&amp;')
        expect(email).to have_body_text(/Test containing A & B/)
      end

      it 'should send an email when the preference is to subscribe' do
        user.prefs.update_column(:involve_my_locations, 'subscribe')
        fill_in_issue
        click_on 'Send Report'
        email = open_last_email_for(user.email)
        expect(email).not_to be_nil
      end

      it "should not send an email when the emails aren't enabled" do
        user.prefs.update_column(:email_status_id, 0)
        fill_in_issue
        click_on 'Send Report'
        email = open_last_email_for(user.email)
        expect(email).to be_nil
      end
    end

    describe 'for users in groups with overlapping locations' do
      let!(:group_profile) { create(:quahogcc_group_profile) }
      let!(:notifiee) { create(:user) }
      let!(:group_membership) { create(:group_membership, user: notifiee, group: group_profile.group) }

      before do
        notifiee.prefs.update_column(:involve_my_groups, 'notify')
        notifiee.prefs.update_column(:email_status_id, 1)
      end

      it 'should send a notification' do
        fill_in_issue
        click_on 'Send Report'
        email = open_last_email_for(notifiee.email)
        expect(email).to have_subject("[Cyclescape] New issue - \"#{issue_values[:title]}\" (#{group_profile.group.name})")
        email_body = email.text_part.decoded
        expect(email_body).to include("in the #{group_profile.group.name}'s area")
        expect(email_body).to include(issue_values[:description])
        expect(email_body).to include(issue_values[:title])
      end

      it "shouldn't send a notification if the user doesn't want it" do
        notifiee.prefs.update_column(:involve_my_groups, 'none')
        fill_in_issue
        click_on 'Send Report'
        email = open_last_email_for(notifiee.email)
        expect(email).to be_nil
      end
    end
  end

  context 'multiple overlapping locations' do
    let(:location_category) { create :location_category }
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:user_location) { create(:user_location, user: user, location: 'POLYGON ((0.1 0.1, 0.1 0.2, 0.2 0.2, 0.2 0.1, 0.1 0.1))') }

    before do
      user.prefs.update_column(:involve_my_locations, 'notify')
      user.prefs.update_column(:email_status_id, 1)
      user2.prefs.update_column(:involve_my_locations, 'notify')
      user2.prefs.update_column(:email_status_id, 1)
      visit new_issue_path
      fill_in 'Title', with: 'Test'
      fill_in 'Write a description', with: 'Something & something else'
      find('#issue_loc_json', visible: false).set(user_location.loc_json)
    end

    it 'should not send multiple emails to the same user' do
      email_count = all_emails.count
      click_on 'Send Report'
      expect(all_emails.count).to eql(email_count + 1)
    end

    context 'multiple users' do
      let!(:user2_location) do
        create(:user_location, user: user2, location: 'POLYGON ((0.1 0.1, 0.1 0.2, 0.2 0.2, 0.2 0.1, 0.1 0.1))')
      end

      it 'should send one email to multiple users' do
        email_count = all_emails.count
        click_on 'Send Report'
        expect(all_emails.count).to eql(email_count + 2)
      end
    end
  end

  context 'overlapping group and user locations' do
    let(:location) { 'POLYGON ((0.1 0.1, 0.1 0.2, 0.2 0.2, 0.2 0.1, 0.1 0.1))' }
    let(:user) { create(:user) }
    let!(:user_location) { create(:user_location, user: user, location: location) }
    let!(:group_profile) { create(:group_profile, location: location) }
    let!(:group_membership) { create(:group_membership, user: user, group: group_profile.group) }

    before do
      user.prefs.update_column(:involve_my_locations, 'notify')
      user.prefs.update_column(:involve_my_groups, 'notify')
      user.prefs.update_column(:email_status_id, 1)
      visit new_issue_path
      fill_in 'Title', with: 'Test'
      fill_in 'Write a description', with: 'Interesting, but you only need to tell me once'
      find('#issue_loc_json', visible: false).set(user_location.loc_json)
    end

    # The user would normally receive two emails - one for the issue being within the group's area,
    # and a second email since the issue is also in one of their user locations.
    it 'should only send one email to the user' do
      email_count = all_emails.count
      click_on 'Send Report'
      expect(all_emails.count).to eql(email_count + 1)
    end
  end
end
