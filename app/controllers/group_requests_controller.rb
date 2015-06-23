class GroupRequestsController < ApplicationController
  before_filter :load_group_request, only: [:show, :edit, :update, :destroy, :review, :confirm, :reject]

  def index
    @requests = GroupRequest.order('created_at desc').includes(:user)
  end

  def new
    @request = GroupRequest.new
  end

  def create
    @request = GroupRequest.new params[:group_request]
    @request.user = current_user

    if @request.save
      Notifications.new_group_request(@request, User.admin).deliver
      redirect_to '/', notice: t('.group_requests.create.requested')
    else
      render :new
    end
  end

  def review

  end

  def confirm
    @request.actioned_by = current_user
    if res = @request.confirm
      @group = Group.find_by_name!(@request.name)
      Notifications.group_request_confirmed(@group, @request).deliver
      set_flash_message(:success)
    else
      set_flash_message(:failure)
    end
    redirect_to action: :index
  end

  def reject
    @request.actioned_by = current_user
    @request.update_attributes params[:group_request]
    if @request.reject
      Notifications.group_request_rejected(@request).deliver
      set_flash_message(:success)
    else
      set_flash_message(:failure)
    end
    redirect_to action: :index
  end

  def destroy
    if @request.destroy
      set_flash_message(:success)
    else
      set_flash_message(:failure)
    end
    redirect_to action: :index
  end

  def cancel
    if @request.user == current_user && @request.cancel
      set_flash_message(:success)
    else
      set_flash_message(:failure)
    end
    redirect_to @group
  end

  protected

  def load_group_request
    @request = GroupRequest.find(params[:id])
  end
end
