class ApplicationController < ActionController::Base

  protect_from_forgery
  include AuthenticationHelper

  before_filter :set_locale
  around_filter :catch_not_found

  #Metodo  para setear el lenguaje que el usuario usa
  #Parametros de entrada: lenguaje del usuario
  def set_locale
    lang = current_user.language if signed_in? #Chequar si es de hecho un idioma valido
    I18n.locale = params[:locale] || (lang if Languages.member?(lang)) || extract_locale_from_http_header || I18n.default_locale
    add_breadcrumb I18n.t('general.home'), :root_url
  end

  private

  #Metodo para setear el lenguaje por medio del http request
  def extract_locale_from_http_header
    if (req = request.env['HTTP_ACCEPT_LANGUAGE'])
      lang = req.scan(/^[a-z]{2}/).first
      lang if Languages.member?(lang)
   end
  end

  #Metodo para setear el lenguaje por defecto
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  #Metodo para capturar los errores de reqistros no encontrados en cualquier metodo llamado
  #Salida: Se redirige a la pagina principal
  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :flash => { :error => t("general.record_not_found") }
  end

  # agrega la accion actual al breadcrumb
  def add_current_to_breadcrumb(str)
    add_breadcrumb str, request.fullpath
    #add_breadcrumb str, {:controller => controller_name, :action => action_name, :params => params.except(:controller,:action,:locale)}
  end

end
