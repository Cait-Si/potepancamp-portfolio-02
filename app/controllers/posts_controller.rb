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

  def show
    @post = Post.find(params[:id])
    @messages = Message.where(post_id: params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, notice: "削除しました"
    else
      flash.now[:alert] = "削除に失敗しました"
      render 'show'
    end
  end

  def search
    @posts = Post.where('title LIKE(?) or location LIKE(?)', "%#{params[:keyword]}%", "%#{params[:keyword]}%").order(datetime: :desc)
    if @posts.empty?
      flash.now[:alert] = "該当する検索結果がありませんでした"
    end
    render 'index'
  end

  private
    def post_params
      params.require(:post).permit(:title, :person, :level, :datetime, :location, :description, :deadline)
    end
end
