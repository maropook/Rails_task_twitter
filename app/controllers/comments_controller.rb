class CommentsController < ApplicationController
    def create

        @post = Post.find(params[:post_id])
        @comments =@post.comments
        @comment = Comment.new(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
        render :post_comments

        else
        redirect_back(fallback_location: root_path)
        end
    end

    def destroy
      Comment.find_by(id: params[:id], post_id: params[:post_id]).destroy
      @post = Post.find(params[:post_id])
      @comments =@post.comments
      render :post_comments
    end


    private
    def comment_params
      params.require(:comment).permit(:content, :post_id) #追加
    end
end
