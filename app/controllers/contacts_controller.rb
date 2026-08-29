class ContactsController < ApplicationController
  before_action :set_user
  def index
    @user = User.first
    @contacts = @user.personal_contacts
    @users = User.where.not(id: @user.id)
  end

  def create
    @user = User.first
    contact = User.find(params[:contact_id])
    @contact = @user.contacts.build(contact: contact)
    if @contact.save
      redirect_to contacts_path(@user), notice: "Contact was successfully created."
    else
      redirect_to contacts_path(@user), alert: @contact.errors.full_messages.to_sentence
    end
  end

  def destroy
    @user = User.first
    @contact = @user.contacts.find(params[:id])
    @contact.destroy
    redirect_to user_contacts_path(@user), notice: "Contact was successfully deleted."
  end

  private
  def set_user
    # Temporary until proper authentication
    @user = User.first
  end
end
