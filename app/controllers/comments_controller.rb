class CommentsController < ApplicationController
  before_filter :ensure_user

  around_filter :check, :except => [:create]

  # Se crea un comentario nuevo
  def create
    @comment = Comment.new
    @comment.content_id = params[:id]
    if ensure_project_access(@comment.content.project.id)
      @comment.comment = params[:comment][:comment]
      @comment.user_id = current_user.id
      if @comment.save
        redirect_to project_path(@comment.content.project, :tab=>'1'), flash: {project_success: I18n.t('comment.create_success')}
      else
        redirect_to project_path(@comment.content.project, :tab=>'1'), flash: {project_error: I18n.t('comment.error_create')}
      end
    end
  end

  # Se actualiza un comentario ya existente
  def update
    # comment ya lo carga la funcion check
    if @comment.update_attributes(:comment => params[:comment])
      redirect_to project_path(@comment.content.project, :tab=>'1'), flash: {project_success: I18n.t('comment.update_success')}
    else
      render 'edit'
    end
  end

  # Se elimina un comentario
  def destroy
    # comment ya lo carga la funcion check
    @comment.destroy
    render :nothing => true
  end

  private

  # Se carga un comentario en la variable @comment
  def check
    @comment = Comment.find(params[:id])
    if session[:user_id] and (current_user.is_admin or @comment.user_id == current_user.id)
      yield
    else
      flash[:notice] = I18n.t('general.access_denied')
      redirect_to root_url
    end
  end

end
