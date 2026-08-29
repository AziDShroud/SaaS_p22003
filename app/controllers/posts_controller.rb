class PostsController < ApplicationController
  def index
    @categories = Category.all
    @posts = Post.joins(:category)

    # Filter by category if selected
    if params[:category_id].present?
      @posts = @posts.where(category_id: params[:category_id])
    end

    # Search keyword in title or content
    if params[:query].present?
      query = "%#{params[:query].downcase}%"
      @posts = @posts.where("LOWER(posts.title) LIKE :q OR LOWER(posts.content) LIKE :q OR LOWER(categories.name) LIKE :q", q: query)
    end

    @posts = @posts.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    # temporary assignment of first user until authentication is added
    @post = User.first.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  private
  def post_params
    params.require(:post).permit(:title, :content, :category_id)
  end
end
