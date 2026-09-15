class TodosController < ApplicationController
  before_action :authorize_request
  before_action :set_todo, only: [:show, :update, :destroy]
  #GET /todos
  def index
    @todos = @current_user.todos.includes(:items)
    render json: @todos.as_json(include: :items), status: :ok
  end
  #POST /todos
  def create
    @todo = @current_user.todos.build(todo_params)

    if @todo.save
      render json: @todo, status: :created
    else
      render json: {errors: @todo.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #GET /todos/:id
  def show
    render json: @todo, status: :ok
  end

  #PUT /todos/:id
  def update
    if @todo.update(todo_params)
      render json: @todo, status: :ok
    else
      render json: {errors: @todo.errors.full_messages}, status: :unprocessable_entity
    end
  end

  #DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end
  private

  def todo_params
    params.permit(:title)
  end

  def set_todo
    @todo = @current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {error: " Todo Not Found"}, status: :not_found
  end

end
