class StaticPagesController < ApplicationController
  def home
<<<<<<< HEAD
=======
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
>>>>>>> dab5974b994c4b42995a223f7f7f2e5106a1ebea
  end

  def help
  end
<<<<<<< HEAD
=======

  def about
  end

  def contact
  end
>>>>>>> dab5974b994c4b42995a223f7f7f2e5106a1ebea
end
