class ContactsController < ApplicationController
  before_action :authenticate_user!
  def index

    @contacts = current_user.contacts.includes(:contact)
    # Exclude current user and already added contacts from dropdown
    existing_contact_ids = current_user.contacts.pluck(:contact_id)
    @users = User.where.not(id: [current_user.id] + existing_contact_ids)
  end

  def create
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      redirect_to contacts_path, notice: "Contact was successfully created."
    else
      redirect_to contacts_path, alert: @contact.errors.full_messages.to_sentence, status: :see_other
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
