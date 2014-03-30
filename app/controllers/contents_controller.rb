class ContentsController < ApplicationController

  before_filter :ensure_user
  before_filter :ensure_admin, :except => [:create, :show_all_comments] # :new, :create, :destroy
  before_filter :ensure_project_access, :only => [:create]

  # POST /contents
  # Se crea un contenido nuevo
  def create
    @content = Content.new(params[:content].except(:user_id))
    project = Project.find(params[:project_id]);
    if current_user.is_admin? || project.client.contacts.find(current_user.id)
      if current_user.is_admin?
        @content.access_client = (params[:visibility_client]) ? true : false
        @content.access_moove_it = (params[:visibility_mooveit]) ? true : false
      else
        @content.access_client = (current_user.class == Contact)
        @content.access_moove_it  = (current_user.class != Contact)
      end

      @content.user_id = current_user.id
      @content.project_id = project.id

      if @content.save
        redirect_to project_path(@content.project, :tab=>'1'), flash: {project_success: I18n.t('content.create_success')}
      else
        @project = project
        add_breadcrumb I18n.t('project.projects'), :controller => 'projects', :action => 'index'
        add_breadcrumb @project.name, project_path(@project)
        render 'show_add'
      end
    end
  end

  # PUT /contents/1
  #Se actualiza un contenido ya existente
  def update
    content = Content.find(params[:id_content])
    if ensure_project_access(content.project)
      @content = content
      if @content.update_attributes(params[:content])
        flash[:project_success] = I18n.t('content.update_success')
        redirect_to project_path(@content.project, :tab=>'1')
      else
        @project = @content.project
        add_breadcrumb I18n.t('project.projects'), :controller => 'projects', :action => 'index'
        add_breadcrumb @project.name, project_path(@project)
        add_current_to_breadcrumb I18n.t('content.modify')
        render 'show_edit_errors'
      end
    end
  end

  # Se da de baja un contenido
  def destroy
    @content = Content.find(params[:id])
    @content.destroy
    redirect_to project_path(@content.project, :tab=>'1')
  end

  # Se actualiza la valoración de un contenido
  def content_ranking
    @project = Project.find(params[:id])
    @content = Content.find(params[:id_content])
    @content.ranking = params["ranking"]
    @content.save
    redirect_to :back
  end

  # Se muestran todos los comentarios de un contenido
  def show_all_comments
    content = Content.find(params[:id])
    if ensure_project_access(content.project_id)
      @content = content
      @project = Project.find(@content.project_id)
      add_breadcrumb I18n.t('project.projects'), projects_path
      add_breadcrumb @project.name, project_path(@project)
      add_breadcrumb I18n.t('content.all_message'), :controller => 'contents', :action => 'show_all_comments'
    end
  end

  # Se modifica la visibilidad de un contenido
  def modify_visibility
    @content = Content.find(params[:id])
    @content[params[:vis]] = !@content[params[:vis]]
    if @content.save
      flash[:project_success] = I18n.t('content.visibility_success')
    end
    redirect_to :back
  end

end
