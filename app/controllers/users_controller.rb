class UsersController < ApplicationController
  include IsAmPm
  before_action :is_am_pm
  before_action :authenticate_user!, :only => [:show, :myself, :history]

  def isReadTimeNow
    @time = Time.current.to_s(:time_clock)
    @now = time.to_i
    if  (current_user.readtime <=  current_user.readlimit)
      if (current_user.readtime <= now  &&  now <=current_user.readlimit)
      @isReadTimeNow= true
      else
      @isReadTimeNow= false
      end
    else

      if (current_user.readtime <= now  ||  now<=  current_user.readlimit)
      @isReadTimeNow= true
      else
      @isReadTimeNow= false
      end
    @isReadTimeNow= false
    end
  end


  def index
    @users=User.all
  end

  def show
    @users=User.all
    @user=User.find(params[:id])
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end


  def detail
    @users=User.all
    @user=User.find(params[:id])
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end


  def calendar
    @user=User.find(params[:id])
    @posts = Post.where(user_id: @user.id)

  end

  def calendar_day
    @user=User.find(params[:id])
    @posts = Post.where(user_id: @user.id)

  end

  def myself
    @isReadTimeNow
    @user= current_user
    @myselfs = Post.where(user_id: current_user.id).where("created_at >= ?", Time.zone.now.beginning_of_day).order(:created_at)
  end

  def history
    @isReadTimeNow
    @user= current_user
    @myselfs = Post.where(user_id: current_user.id).order(:created_at)
  end

end
