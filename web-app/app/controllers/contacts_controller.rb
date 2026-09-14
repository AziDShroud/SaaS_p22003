class ContactsController < ApplicationController
  before_action :authenticate_user!
  def index

    @contacts = current_user.contacts.includes(:contact)
    # Restrict dropdown exclusively to members of shared groups (excluding existing contacts and self)
    shared_group_ids = GroupMembership.where(user_id: current_user.id).pluck(:group_id)
    group_peer_ids = GroupMembership.where(group_id: shared_group_ids).pluck(:user_id).uniq

    # Exclude current user and already added contacts from dropdown
    existing_contact_ids = current_user.contacts.pluck(:contact_id)
    @users = User.where(id: group_peer_ids).where.not(id: [current_user.id] + existing_contact_ids)
  end

  def create
    @contact_user= User.find(params[:contact_id])
    if @contact_user == current_user
      redirect_back fallback_location: posts_path, alert: "You cannot add yourself as a contact"
      return
    end
    # Find or initialize contact for current_user
    @contact = current_user.contacts.find_or_initialize_by(contact_id: @contact_user.id)
    if @contact.save
      redirect_back fallback_location: posts_path, notice: "#{@contact_user.name || @contact_user.email} added to contacts!"
    else
      redirect_back fallback_location: posts_path, alert: "Could not add contact."
    end
  end

  def destroy
    @user = User.first
    @contact = current_user.contacts.find(params[:id])
    @contact.destroy
    redirect_to contacts_path, notice: "Contact removed successfully.", status: :see_other
  end

  private

  def contact_params
    params.require(:contact).permit(:contact_id)
  end
end
