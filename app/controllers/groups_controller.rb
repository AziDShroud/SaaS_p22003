class GroupsController < ApplicationController
  before_action :set_user
  before_action :set_group, only: [:show, :destroy]
  def index
    @groups = @user.groups
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.group_memberships.create!(user: @user, role: "owner")
      redirect_to group_path(@group), notice: "Group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @members = @group.users
    @users = User.where.not(id: @members.pluck(:id))
  end

  def new
    @group = Group.new
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: "Group was successfully deleted."
  end
  private
  def set_user
    @user = User.first
  end
  def set_group
    @group = @user.groups.find(params[:id])
  end
  def group_params
    params.require(:group).permit(:name, :description)
  end
end
