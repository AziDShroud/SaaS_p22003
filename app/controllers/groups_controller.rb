class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show,:edit,:update,:destroy]
  before_action :authorize_owner!, only: [:edit, :update,:destroy]
  def index
      @groups = current_user.groups
  end
  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def edit
  end
  def create
    @group = current_user.groups.build(group_params)
    if @group.save
      @group.group_memberships.create(user: current_user)
      redirect_to @group, notice: "Group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show

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
    @group = Group.find(params[:id])
  end
  def authorize_owner!
    unless @group.user == current_user
      redirect_to groups_path, alert: "You are not the owner of this group."
    end
  end
  def group_params
    params.require(:group).permit(:name, :description)
  end
end
