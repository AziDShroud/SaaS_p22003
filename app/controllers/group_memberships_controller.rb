class GroupMembershipsController < ApplicationController
  before_action :set_user
  before_action :set_group

  def create
    user = User.find(params[:user_id])

    membership = @group.group_memberships.build(user: user, role: "member")
    if membership.save
      redirect_to group_path(@group), notice: "User added to the group"
    else
      redirect_to group_path(@group), alert: membership.errors.full_messages.to_sentence
    end
  end
  def destroy
    membership = @group.group_memberships.find(params[:id])
    membership.destroy
    redirect_to group_path(@group), notice: "User removed from the group"
  end
  private
  def set_user
    @user = User.first
  end
  def set_group
    @group = @user.groups.find(params[:group_id])
  end
end
