require "spec_helper"

describe "Issue threads" do
  let!(:issue) { FactoryGirl.create(:issue) }

  context "new" do
    context "as a site user" do
      include_context "signed in as a site user"

      it "should create a new public thread" do
        visit issue_path(issue)
        click_on "Discuss"
        fill_in "Message", with: "Awesome!"
        click_on "Create Thread"
        page.should have_content(issue.title)
        page.should have_content("Awesome!")
        current_user.subscribed_to_thread?(issue.threads.last).should be_true
      end

      it "should pre-fill the title for the thread" do
        visit issue_path(issue)
        click_on "Discuss"
        find_field("Title").value.should eq(issue.title)
      end

      it "should not pre-fill the title for the second thread" do
        visit issue_path(issue)
        click_on "Discuss"
        fill_in "Message", with: "Awesome!"
        click_on "Create Thread"
        visit issue_path(issue)
        click_on "New Thread"
        find_field("Title").value.should be_nil
      end
    end

    context "as a group member" do
      include_context "signed in as a group member"

      it "should still create a new public thread" do
        visit issue_path(issue)
        click_on "Discuss"
        fill_in "Message", with: "Awesome!"
        click_on "Create Thread"
        page.should have_content(issue.title)
        page.should have_content("Awesome!")
        page.should have_content("Public: Everyone can view this thread and post messages.")
      end

      it "should create a new public group thread" do
        visit issue_path(issue)
        click_on "Discuss"
        select current_group.name, from: "Owned by"
        fill_in "Message", with: "Awesome!"
        select "Public", from: "Privacy"
        click_on "Create Thread"
        page.should have_content(issue.title)
        page.should have_content("Awesome!")
        page.should have_content("Public: Everyone can view this thread and post messages.")
      end

      it "should create a new private group thread" do
        visit issue_path(issue)
        click_on "Discuss"
        select current_group.name, from: "Owned by"
        fill_in "Message", with: "Awesome!"
        select "Group", from: "Privacy"
        click_on "Create Thread"
        page.should have_content(issue.title)
        page.should have_content("Awesome!")
        page.should have_content("Private: Only members of #{current_group.name} can view and post messages to this thread.")
      end
    end
  end

  context "group private thread" do
    let!(:thread) { FactoryGirl.create(:group_private_message_thread, issue: issue) }
    context "as an admin" do
      include_context "signed in as admin"

      it "should show you a link to the thread" do
        visit issue_path(issue)
        page.should have_content(thread.title)
        page.should have_content("Group Private")
        page.should have_link(thread.title)
      end
    end
  end
end
