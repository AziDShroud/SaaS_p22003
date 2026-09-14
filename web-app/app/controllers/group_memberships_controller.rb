class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def create
    @membership = @group.group_memberships.find_or_initialize_by(user: current_user)

    if @membership.save
      redirect_back fallback_location: posts_path, notice: "You have joined the group!"
    else
      redirect_back fallback_location: posts_path, alert: "Unable to join group."
    end
  end

  def destroy
    @membership = @group.group_memberships.find_by(id: params[:id]) || @group.group_memberships.find_by(user_id: current_user.id)

    unless @membership
      redirect_back fallback_location: posts_path, alert: "Membership not found."
      return
    end

    # Authorization: Only the group owner OR the member themselves can delete a membership
    if @group.user == current_user || @membership.user == current_user
      @membership.destroy
      redirect_back fallback_location: posts_path, notice: "You have left/removed the member from the group."
    else
      redirect_back fallback_location: posts_path, alert: "You are not authorized to perform this action."
    end
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
    params.fetch(:group_membership, {}).permit(:user_id, :role)
  end
end