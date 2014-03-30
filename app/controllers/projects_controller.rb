class ProjectsController < ApplicationController

  before_filter :init
  before_filter :ensure_user
  before_filter :ensure_admin, :only => [:new, :create]
  before_filter :ensure_mooveit, :only => [:index] # contactos deberian usar my_projects
  before_filter :ensure_project_access, :only => [:show,:file]

  # Agrega el breadcrumb del indice de proyectos
  def init
    if current_user.instance_of? Contact
      add_breadcrumb I18n.t('project.list'), :action => "my_projects"
    else
      add_breadcrumb I18n.t('project.list'), :action => "index"
    end
  end

  # GET /projects
  # Metodo que lista los proyectos
  # lista todos los proyectos, para usuarios mooveit
  # Parametros de entrada: Ninguno
  # Salida: Lista de proyectos, contenida en la variable @projects
  def index
    # Lista todos los proyectos
    @projects = Project.all
  end

  # GET /projects/1
  # Metodo que muestra toda la informacion acerca de un proyecto dado, pasado por parametro
  # Parametros de entrada: Id del proyecto
  # Salida: Muestra todos los datos asociados al proyecto
  def show
    @focus_tab=params[:tab]
    # Se fija si hay que mostrar una tab especial al hacer el show,
    # sino, muestra la primera
    if @focus_tab== nil
      @focus_tab='1'
    end
    # Busca el proyecto por el id y lo muestra
    @project = Project.find(params[:id])
    # Agrega el breadcrumb con el nombre del proyecto
    add_breadcrumb @project.name, project_path(@project)
  end

  # GET /projects/new
  # Metodo que muestra la pagina new de proyecto, para poder crear un proyecto nuevo
  # Parametros de entrada: Ninguno
  # Salida: Pagina new de proyecto
  def new
    # Agrega el breadcrumb de la pagina new de proyecto
    add_breadcrumb I18n.t('project.new'), :controller => "projects", :action => "new"
    @project = Project.new
  end

  # POST /projects
  # Metodo que crea un proyecto nuevo
  # Parametros de entrada: nombre del proyecto, id del cliente asociado al proyecto, descripcion,
  #                        fecha de inicio, fecha de fin del proyecto
  # Salida: Se crea el proyecto y se redirige a la pagina show del proyecto creado
  def create
    @project = Project.new(params[:project])
    # Si se crea correctamente, se guarda y se redirige al show con un mensaje de exito,
    # sino, se hace un render al new del proyecto, dando el mensaje de error correspondiente
      if @project.save
        redirect_to @project, flash: {success: I18n.t('project.create_success')}
      else
        render 'new'
      end
  end

  # DELETE /projects/1
  # Metodo que borra un proyecto dado
  # Parametros de entrada: Id del proyecto
  # Salida: Se redirige projects_url
  def destroy
    # Se busca el proyecto por el id
    @project = Project.find(params[:id])
    # Se destruye
    @project.destroy
    redirect_to projects_url
  end

  # Metodo que muestra todos los proyectos del cliente asociado al usuario actual
  # Parametros de entrada: Id del cliente asociado al usuario actual
  # Salida: Lista todos los proyectos del cliente
  def my_projects
    @projects = Project.where(:client_id => current_user.client_id)
  end

  # Metodo que archiva un proyecto dado
  # Parametros de entrada: Id del proyecto a archivar
  # Salida: Se redirige a la pagina index de proyectos con un mensaje de exito
  def file
    # Se busca el proyecto
    @project = Project.find(params[:id])
    # Se archiva, seteandole un atributo del mismo en true
    @project.update_column(:filed, true)
    redirect_to :back, flash: {success: t('project.filed')}
  end

end
