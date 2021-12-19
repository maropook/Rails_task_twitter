class CommentsController < ApplicationController
    def create

        @post = Post.find(params[:post_id])
        @comments =@post.comments
        @comment = Comment.new(comment_params)

        @comment.user_id =current_user.id
        current_user.today_comments_count += 1

        if @comment.save
          current_user.save
          redirect_back(fallback_location: root_path)
        # render :post_comments

        else
        redirect_back(fallback_location: root_path)
        end
    end

    def destroy
      Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
      @post = Post.find(params[:post_id])
      @comments = @post.comments
      redirect_back(fallback_location: root_path)
      # render :post_comments
    end


    private
    def comment_params
      params.require(:comment).permit(:content, :post_id,:is_random_dialy) #追加
    end
end
