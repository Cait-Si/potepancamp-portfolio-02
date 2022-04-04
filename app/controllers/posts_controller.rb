class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = Post.order(datetime: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :person, :level, :datetime, :location, :description, :deadline)
    end
end
