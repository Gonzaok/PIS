module AuthenticationHelper

  def signed_in?
    !session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  #def ensure_signed_in
  #  unless signed_in?
  #    session[:redirect_to] = request.request_uri
  #    redirect_to(new_session_path)
  # end
  #end

  def ensure_mooveit
    # Chequear si hay un usuario logeado
    u = session[:user_id] && current_user
    # Si no hay un usuario logeado o el mismo no es un contaco, no darle permiso
    if  !u || u.class == Contact
      flash[:notice] = I18n.t('general.access_denied')
      # Enviar hacia atras si habia un HTTP_REFERER
      redirect_to root_url
    end
  end

  def ensure_user
    u = session[:user_id] && current_user
    # Si no hay un usuario logeado
    if !u
      flash[:error] = I18n.t('general.access_denied')
      # Enviar hacia atras si habia un HTTP_REFERER
      redirect_to root_url
    end
  end

  def ensure_admin
    u = session[:user_id] && current_user
    if  !u || !u.is_admin?
      flash[:error] = I18n.t('general.access_denied')
      redirect_to root_url
    end
  end

  # Chequar si un usuario tiene permisos para acceder a un proyecto
  # si no se pasan argumentos, se asume que params[:project_id]
  # o params[:id] contiene el id del proyecto
  def ensure_project_access(id = nil)
    u = session[:user_id] && current_user
    id ||= params[:project_id] || params[:id]
    if !u || !u.can_access?(id)
      flash[:notice] = I18n.t('general.access_denied')
      redirect_to root_url
      false
    else
      true
    end
  end

end
