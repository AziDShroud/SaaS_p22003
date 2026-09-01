class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :authorize_owner!

  def create
    user_id = membership_params[:user_id]
    if user_id.blank?
      redirect_to @group, alert: "User not found"
      return
    end

    membership = @group.group_memberships.build(membership_params)
    if membership.save
      redirect_to @group, notice: "Member added to the group"
    else
      redirect_to @group, alert: membership.errors.full_messages.to_sentence
    end
  end
  def destroy
    membership = @group.group_memberships.find(params[:id])
    membership.destroy
    redirect_to @group, notice: "Member removed from the group", status: :see_other
  end
  private
  def set_group
    @group = Group.find(params[:group_id])
  end
  def authorize_owner!
    unless @group.user == current_user
      redirect_to @group, alert: "Only the owner can manage members."
    end
  end
  def membership_params
    params.require(:group_membership).permit(:user_id)
  end
end
