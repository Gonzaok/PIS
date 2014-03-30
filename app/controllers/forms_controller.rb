require 'csv'

class FormsController < ApplicationController

  before_filter :init
  before_filter :ensure_mooveit
  before_filter :ensure_admin, :only => [:new, :create, :destroy]

  # Agrega el breadcrumb del indice de formularios
  def init
    add_breadcrumb I18n.t('form.forms'), :controller => "forms", :action =>  "index"
  end

  # GET /forms
  # Metodo que lista todos los formularios
  # Parametros de entrada: Ninguno
  # Salida: Lista de formularios, contenida en la variable @projects
  def index
    @forms = Form.all
  end

  # GET /forms/new
  # Metodo que muestra la pagina new de formulario, para poder crear un formulario nuevo
  # Parametros de entrada: Ninguno
  # Salida: Pagina new de formulario
  def new
    add_breadcrumb I18n.t('form.new'), :controller => "forms", :action => "new"
    @form = Form.new
  end

  # POST /forms
  # Metodo que crea un formulario
  # Parametros de entrada: titulo del formulario, url doc admin, url doc cliente, descripción
  #                        idioma, fecha
  # Salida: Se crea el formulario y se redirige a la pagina de listado de formularios si es que hubo error,
  #         sino se redirige devuelta a la view de new emitiendo los errores correspondientes
  def create
    @form = Form.new(params[:form])
    @form.date = Time.now
    if @form.save
      redirect_to forms_url, flash: {success: I18n.t('form.create_success')}
    else
      render 'new'
    end
  end


  # DELETE /forms/1
  # Metodo que borra un formulario dado
  # Parametros de entrada: Id del formulario
  # Salida: Se redirige form_url
  def destroy
    @form = Form.find(params[:id])
    @form.destroy
    redirect_to forms_url
  end

  # Metodo para obtener por ajax los proyectos de un cliente
  # Parametros de entrada: Id del cliente
  # Salida: Json con los parametros de los proyectos
  def get_projects
    @projects = Project.where(:client_id => params[:id])
    render :json => @projects, :nothing => true
  end

  # Metodo para ver la pagina para mandar un formulario a los contactos de un cliente por email
  # Parametros de entrada: Id del formulario
  # Salida: Pagina send_view de formulario
  def send_view
    #add_breadcrumb I18n.t('form.send'), {:controller => controller_name, :action => action_name, :id => params[:id]}
    add_current_to_breadcrumb I18n.t('form.send')
    @form_id = params[:id]
    @clients = Client.all.map{|a| [a.name, a.id]}.unshift ['',nil]
  end

  # Metodo para mandar un formulario a los contactos de un cliente por email
  # Parametros de entrada: Id cliente, Id proyecto, asunto, mensaje
  # Salida: Se manda el formulario a los contactos con un asunto y mensaje
  #         y se redirige a la view de listar formularios
  def send_form
    aux = params[:form_send]
    contacts = Contact.where(:client_id => aux[:clients])
    url = Form.find(params[:id]).client_url
    pro = Project.find(aux[:projects])

    contacts.each do |c|
      Notifier.send_form(pro, c, aux[:subject], aux[:message], url).deliver
    end

    flash[:success] = I18n.t 'form.email_success'
    redirect_to :controller => 'forms', :action => :index
  end

  # Metodo para ver el resumen de un formulario
  # Parametros de entrada: Id del formulario
  # Salida: Se muestra la view donde se elige ver el resumen general del formulario o ver el resumen
  #         de un proyecto perteneciente al formulario
  def summary
    @clients = Client.all.map{|a| [a.name, a.id]}.unshift ['',nil]
    @form = Form.find(params[:id])
    add_current_to_breadcrumb @form.title
  end

  # Metodo para obtener el google token para ver un formulario
  # Parametros de entrada: Id del formulario, id del proyecto
  # Salida: Se redirige a la pagina de google para pedir permiso para obtener acceso a los datos del formulario
  def summary_token
    next_url = {:controller => 'forms', :action => 'show_summary', :id => params[:id], :proj_id => params[:proj_id]}
    unless session[:token]
      scope = 'https://docs.google.com/feeds'
      secure = false
      sess = true
      next_url = GData::Auth::AuthSub.get_url(url_for(next_url), scope, secure, sess)
    end
    redirect_to next_url
  end

  # Metodo para ver el resumen de un formulario
  # Parametros de entrada: Id del formulario, id del proyecto y token si es que ya esta seteado en la session
  # Salida: Se muestra la grafica que muestra el resultado general del proyecto elegido
  def show_summary
    begin
      client = GData::Client::Spreadsheets.new
      if not params[:token]
        client.authsub_token = session[:token] # tenia el token
      else
        client.authsub_token = params[:token]
        session[:token] = client.auth_handler.upgrade()
      end
      client.authsub_token = session[:token]
      
      form = Form.find(params[:id])
      @project = Project.find(params[:proj_id])

      @client = @project.client_id
      summary

      key = form.admin_url.match(/key=(\w+)/)[1]
      spreadsheet = client.get("https://docs.google.com/feeds/download/spreadsheets/Export?key=#{key}&exportFormat=csv")
      @spreadsheet = CSV.parse(spreadsheet.body)
    rescue ActiveRecord::RecordNotFound
      redirect_to forms_path, :flash => { :error => I18n.t('general.invalid') }
    rescue
      session.delete :token
      redirect_to forms_path, :flash => { :error => I18n.t('form.access_error') }
    end
  end

end
