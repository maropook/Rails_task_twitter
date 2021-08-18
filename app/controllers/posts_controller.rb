class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  def index
    #フォローしているユーザーの投稿
    @posts = Post.where(status: :released, cronstatus: 1)
    @post = Post.new
  end

  def follow
    @nonposts = Post.where(user_id: [*current_user.following_ids],status: :nonreleased, cronstatus: 1)
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    @like = Like.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @post = Post.find(params[:id])
   end
 
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :new
    end
  end

  def destroy
    @post =Post.find(params[:id])
    @post.destroy
    redirect_to request.referer
  end

  private
    def post_params
      params.require(:post).permit(:content,:image, :image_cache, :remove_image, :status)

    end
end

#フォローしているユーザーの投稿
# @posts = Post.where(user_id: [*current_user.following_ids])

#フォローしているユーザーと自分の投稿
# @posts = Post.where(user_id: [current_user.id, *current_user.following_ids])