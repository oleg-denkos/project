class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  helper_method :sort_column, :sort_direction
  before_action :average_rate, :check_rater, only: [:show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new
    @comments = @post.comments 

  end

  def average_rate
    if  @post.rates.average(:rating) == nil
      @post.aver_rate = 0
      @post.save
    else
      @post.aver_rate = @post.rates.average(:rating).round(2)
      @post.save
    end
  end

  def search
    @query = params[:search_posts].presence && params[:search_posts][:query]
    if @query
      @posts = PostsIndex.query(multi_match: {fields: ['title','description','body','user','comments','tags'], query: @query, type: "phrase_prefix"}).objects
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  def check_rater
    if current_user
      @checker = true
      if @post.rates.find_by(user_id: current_user.id) != nil
        @checker = false
      end
    end
  end

  # GET /posts/1/edit
  def edit
  end
  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: t("notice.post")}
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: t("notice.post_update") }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: t("notice.post_destroy") }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :description, :spec, :tag_list)
    end
    
  end
