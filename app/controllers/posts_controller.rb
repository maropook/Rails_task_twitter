class PostsController < ApplicationController
  include IsAmPm
  before_action :is_am_pm
  before_action :authenticate_user!
  before_action :isReadTimeNow
  # , only: [:show, :create]

  def isReadTimeNow
    @time = Time.current.to_s(:time_clock)
    @now = @time.to_i
    if  (current_user.readtime <=  current_user.readlimit)
      if (current_user.readtime <= @now  &&  @now <=current_user.readlimit)
      @isReadTimeNow= true
      else
      @isReadTimeNow= false
      end
    else

      if (current_user.readtime <= @now  ||  @now<=  current_user.readlimit)
      @isReadTimeNow= true
      else
      @isReadTimeNow= false
      end
    @isReadTimeNow= false
    end
  end

  def index
    #フォローしているユーザーの投稿
    @posts = Post.where(status: :released)
    @post = Post.new
  end

  def search
    @users=User.all
    @posts = Post.search(params[:keyword]).where(status: :released)
    @post = Post.new
    @keyword = params[:keyword]
    render "global"
  end

  def searchfollow
    @followings = current_user.followings
    @users=User.all
    @nonposts = Post.search(params[:keyword]).where(user_id: [*current_user.following_ids],status: :nonreleased)
    @post = Post.new
    @keyword = params[:keyword]
    render "follow"
  end

  def global
    @isReadTimeNow
    @users = User.all
    @promotion_users=User.all.where(is_promotion: 1).order(:created_at)
    @posts = Post.where(status: :released).order(:created_at)
    @post = Post.new
  end

  def random
    @users=User.all.where.not(id: current_user.id)
    @posts = Post.where(status: :released,).where.not(user_id: current_user).order(:created_at)
    @post = Post.new
  end

  def follow
    @isReadTimeNow
    @promotion_users=User.all.where(is_promotion: 1).order(:created_at)
    @followings = current_user.followings
    @users=User.all
    @nonposts = Post.where(user_id: [*current_user.following_ids],status: :nonreleased).order(:created_at)
    @post = Post.new
  end

  def record
    @isReadTimeNow
    @post = Post.new
  end

  def other
  end

  def show
    @users=User.all
    @posts = Post.where(status: :released, )
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    @like = Like.new

    @isCommentLimit = current_user.today_comments_count >= current_user.comments_count_limit

  end

  def randomshow
    @users=User.all
    @posts = Post.where(status: :released, )
    @post = Post.find(params[:id])
    @index = params[:index]
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
      redirect_to posts_global_path
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_global_path
  end

  private
    def post_params
      params.require(:post).permit(:content,:image, :image_cache, :remove_image, :status,:start_time)
    end
end

#フォローしているユーザーの投稿
# @posts = Post.where(user_id: [*current_user.following_ids])

#フォローしているユーザーと自分の投稿
# @posts = Post.where(user_id: [current_user.id, *current_user.following_ids])
