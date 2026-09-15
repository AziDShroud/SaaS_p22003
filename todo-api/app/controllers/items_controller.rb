# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_todo
  before_action :set_item, only: [:show, :update, :destroy]

  #GET /todos/:todo_id/items
  def index
    render json: @todo.items, status: :ok
  end

  #GET /todos/:todo_id/items/:id
  def show
    render json: @item, status: :ok
  end

  #POST /todos/:todo_id/items
  def create
    @item = @todo.items.create!(item_params)
    render json: @item, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  #PUT /todos/:todo_id/items/:id
  def update
    if @item.update(item_params)
    render json: @item, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  #DELETE /todos/:todo_id/items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  private
  def item_params
    params.permit(:name, :done)
  end
  def set_todo
    @todo = @current_user.todos.find(params[:todo_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Todo not found" }, status: :not_found
  end
  def set_item
    @item = @todo.items.find(params[:id]) if @todo
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Item not found" }, status: :not_found
  end
end
