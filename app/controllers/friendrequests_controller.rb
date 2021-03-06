class FriendrequestsController < ApplicationController
before_action :authenticate_user!
def index
@user = current_user
@friend = @friend = Friend.find(current_user.id)
@incoming_friendrequests = @user.friendrequests
@outgoing_friendrequests = Friendrequest.where(friend_id: @user.id)
end


def new
 @friendrequest = Friendrequest.new
 @friendrequest.friend_id = current_user.id
 @user = User.find(params[:user_id])
 @friendrequest.user_id = @user.id
end

def create
 @friendrequest = Friendrequest.new
 @friendrequest.friend_id = current_user.id
 @user = User.find(params[:user_id])
 @friendrequest.user_id = @user.id
 @friend = Friend.find(current_user.id)
 if @friendrequest.save
   @user.friends << @friend
   redirect_to @user
 else
   render :new
 end
end

def show

 @friendrequest = Friendrequest.find(params[:id])
 @user = @friendrequest.friend.to_user
end

def edit
 @friendrequest = Friendrequest.find(params[:id])
 @user = @friendrequest.friend
 @friend = current_user
end

def update
 @friendrequest = Friendrequest.find(params[:id])
 @user = @friendrequest.friend.to_user
 @friend = current_user.to_friend
 respond_to do |format|
   if @friendrequest.update(friendrequest_params)
     if @friendrequest.status == "Accept"
     @user.friends << @friend
    end
    if @friendrequest.status == "Decline"
     @friend.to_user.friends.delete(@user.to_friend)
    end
     format.html { redirect_to current_user, notice: 'U are now friends' }
     format.json { render :show, status: :ok, location: @friendrequest }
   else
     format.html { render :edit }
     format.json { render json: @friendrequest.errors, status: :unprocessable_entity }
   end
 end
end
def destroy
  @user = current_user

  @friendrequest = Friendrequest.find(params[:id])
  @friend = @friendrequest.friend

    if @friendrequest.destroy
      @user.friends.delete(@friend)
      redirect_to root_path
    else
      redirect_to @friendrequest
    end
  end

private

def friendrequest_params
 params.require(:friendrequest).permit(:status)
end
end
