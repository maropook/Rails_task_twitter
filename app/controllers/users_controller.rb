class UsersController < ApplicationController
  include IsAmPm
  before_action :is_am_pm
  before_action :authenticate_user!, :only => [:show, :myself, :history]
  def index
    @users=User.all
  end

  def show
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

  def myself
    @user= current_user
    @myselfs = Post.where(user_id: current_user.id).where("created_at >= ?", Time.zone.now.beginning_of_day).order(:created_at)
  end

  def history
    @user= current_user
    @myselfs = Post.where(user_id: current_user.id).order(:created_at)
  end

end
