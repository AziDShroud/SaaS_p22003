class ContactsController < ApplicationController
  before_action :set_user
  def index
    @user = User.first
    @contacts = @user.contacts
    # Exclude current user and already added contacts from dropdown
    existing_contact_ids = @contacts.pluck(:contact_id)
    @users = User.where.not(id: [@user.id] + existing_contact_ids)
  end

  def create
    @user = User.first

    @contact = @user.contacts.build(contact_params)
    if @contact.save
      redirect_to contacts_path(@user), notice: "Contact was successfully created."
    else
      redirect_to contacts_path, alert: @contact.errors.full_messages.to_sentence, status: :see_other
    end
  end

  def destroy
    @user = User.first
    @contact = @user.contacts.find(params[:id])
    @contact&.destroy
    redirect_to contacts_path, notice: "Contact removed successfully.", status: :see_other
  end

  private
  def set_user
    # Temporary until proper authentication
    @user = User.first
  end
  def contact_params
    params.require(:contact).permit(:contact_id)
  end
end
