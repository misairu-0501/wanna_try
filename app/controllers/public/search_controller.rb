class Public::SearchController < ApplicationController
  before_action :authenticate_user!
  
  def search_input
  end

  def search_result
    @posts = []
    results_1 = Post.all.where("title LIKE?", "%#{params[:title]}%").where(genre_id: params[:genre_id]).where(public_status: 0)
    results_1.each do |result_1|
      if result_1.age_range?(params[:age_lower], params[:age_upper]) && result_1.ensure_gender?(params[:gender])
        @posts << result_1
      end
    end
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
  end
end
