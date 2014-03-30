class SetMoodController < ApplicationController

  before_filter :ensure_admin, :only => :create
  skip_before_filter :verify_authenticity_token, :only => [:set_mood, :set_comment]
  skip_before_filter :ensure_signed_in, :only => [:set_mood, :set_comment]

  # Método que crea una solicitud de estado para todos los contactos de un cliente
  # Parametros de entrada: Id de un proyecto
  # Salida: Se redirige a la vista del proyecto
  def create
    project = Project.find_by_id(params[:id_project])
    if project
      if !project.filed
        project.client.send_set_mood_contacts(params[:id_project])
        redirect_to project, flash: {success: I18n.t('set_mood.send_email')}
      else
        redirect_to project, flash: {error: I18n.t('set_mood.cant_send_email')}
      end
    end
  end

  # Método que setea un estado para un proyecto dado a través de un email enviado al contacto
  # Parametros de entrada: Estado elegido por el contacto y token de el pedido de estado
  # Salida: Se redirige a la página que solicita un comentario para el estado seteado
  def set_mood
    setmood = SetMood.find_by_set_mood_token!(params[:token])
    if setmood
  	  @mood = Mood.new(:mood => params[:mood], :comment => params[:comment])
      @mood.add_user(setmood.user.id)
      @mood.add_project(setmood.project.id)
      if @mood.save
        setmood.destroy
        render "set_comment", :layout => "login", :mood => @mood.id
      else
        redirect_to @mood.project, flash: {error: I18n.t('mood.create_error')}
      end
    end
  end

  # Método que setea un comentario en un estado seteado por un contacto a través de su email
  # Parametros de entrada: Id del estado y comentario a agregar
  # Salida: Se redirige a la vista del proyecto
  def set_comment
    @mood = Mood.find(params[:mood])
    if @mood.comment == nil
      @mood.update_attributes(params[:comment])
    else
      redirect_to sessions_url, flash: {success: I18n.t('mood.create_success')}
    end
  end

end
