class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]

  # GET /articles or /articles.json
  def index
    # Obtener todos los artículos
    @articles = Article.all

    # Obtener la lista de nombres de usuarios para el filtrado
    @user_names = User.pluck(:full_name)

    # Filtrar por user.full_name si se proporciona
    @articles = @articles.joins(:user).where(users: { full_name: params[:author] }) if params[:author]

    # Filtrar por created_at si se proporciona un rango
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @articles = @articles.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    end

    # Lógica para quitar los filtros
    if params[:clear_filters]
      # Restaurar la lista completa de artículos
      @articles = Article.all
      # Restaurar la lista completa de nombres de usuarios
      @user_names = User.pluck(:full_name)
      # Limpiar los parámetros de filtro
      params[:author] = nil
      params[:start_date] = nil
      params[:end_date] = nil
    end
  end


  # GET /articles/1 or /articles/1.json
  def show
    @comment = Comment.new
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = current_user.article.build(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:headline, :lead, :body, :user_id, :image)
    end
end
