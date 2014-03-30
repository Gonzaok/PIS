class SearchController < ApplicationController
  respond_to :js

  before_filter :ensure_user
  before_filter :ensure_admin

  LIMIT = 8 # limite para el numero de consultas

  # Metodo que lista usuarios, clientes, proyectos que coinciden con la palabra buscada
  # Parametros de entrada: Palabra a buscar
  # Salida: Lista de usuarios, clientes y proyectos
  def index
    add_breadcrumb I18n.t('general.searcher'), :controller => "search", :action => "index"
    start = Time.now
    # Busca en usuarios
    @users = User.search(params[:search]) if params[:users]
    # Busca en clientes
		@clients = Client.search(params[:search]) if params[:clients]
		# Busca en proyectos
		@projects = Project.search(params[:search]) if params[:projects]
    # Busca en Contenidos
    @contents = Content.search(params[:search]) if params[:contents]

    @time = Time.now - start
  end

  def search_home
    # Busca en usuarios
    @users = User.search(params[:search_focus],LIMIT) || []
    # Busca en clientes
    @clients = Client.search(params[:search_focus],LIMIT) || []
    # Busca en proyectos
    @projects = Project.search(params[:search_focus],LIMIT) || []
    # Busca en Contenidos
    @contents = Content.search(params[:search_focus],LIMIT) || []

    @query = params[:search_focus]

    @limit = LIMIT
  end

end
