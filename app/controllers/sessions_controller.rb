#
# Descripcion: Controlador de la sesion
# Autores: Viviana Solla, Gabriel Jambrina
# Version: 1.0
#
class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_signed_in

  # Log in mediante una cuenta de google
  # Parametros de entrada: Ninguno
  # Salida: Ninguna
  def new
    response.headers['WWW-Authenticate'] = Rack::OpenID.build_header(
        :identifier => "https://www.google.com/accounts/o8/id",
        :required => ["http://axschema.org/contact/email",
                      "http://axschema.org/namePerson/first",
                      "http://axschema.org/namePerson/last"],
        :return_to => session_url,
        :method => 'POST')
    head 401
  end

  # Método que comprueba que el usuario exista en el sistema y guarda el id del usuario en la sesión
  # Parametros de entrada: Email del usuario
  # Salida: Se redirige al home
  def create
    if openid = request.env[Rack::OpenID::RESPONSE]
      case openid.status
      when :success
        ax = OpenID::AX::FetchResponse.from_success_response(openid)
        user= User.where(:email => ax.get_single('http://axschema.org/contact/email')).first
        #Verifico que el usuario este registrado en el sistema
        if user.nil?
           redirect_to sessions_url, flash: {error: I18n.t('session.login_email_error', :user=>ax.get_single('http://axschema.org/contact/email'))}
        else
          session[:user_id] = user.id
          params.delete(:locale)
          set_locale
          redirect_to :controller=>'home', :action=>'index'
        end
      when :failure
        flash[:error] =  I18n.t('session.login_openid_error')
        redirect_to :action => 'index'
      end
    else
      redirect_to new_session_path
    end
  end

  def index
    render :layout => "login"
  end

  # Login con email y password
  # Parametros de entrada: Email y password del usuario
  # Salida: Se redirige al index
  def client_login
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      params.delete(:locale)
      set_locale
      redirect_to :controller=>'home', :action=>'index'
    else # Si hay error:
      #Verifico que el usuario este registrado en el sistema
      if User.find_by_email(params[:email]).nil?
        flash[:error] =  I18n.t('session.login_email_error', :user=> params[:email].to_s)
        redirect_to sessions_url
      else
        #Si email es valido entonces el error es el password
        flash[:error] =  I18n.t('session.login_password_error')
        render "index", :layout => "login"
      end
    end
  end

  # Logout
  # Parametros de entrada: Id del usuario y token para formularios
  # Salida: Se redirige a la página de inicio
  def destroy
    session[:user_id] = nil
    session[:token] = nil # token para formularios
    redirect_to '/'
  end
end
