class ClientsController < ApplicationController

  before_filter :init, :except => [:my_client]
  before_filter :ensure_user
  before_filter :ensure_mooveit, :except => [:my_client]
  before_filter :ensure_admin, :only => [:new, :create]

  def init
    add_breadcrumb I18n.t('client.clients'), :controller => "clients", :action => "index"
  end

  # GET /clients
  # Metodo que muestra todos los clientes
  # Parametros de entrada: Ninguno
  # Salida: Lista de todos los clientes
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # Metodo que muestra la informacion de un cliente dado
  # Parametros de entrada: Id del cliente
  # Salida: Muestra la pagina show.html con toda la informacion del cliente
  def show
    # Busca el cliente por el id
    @client = Client.find(params[:id])
    add_breadcrumb @client.name, client_path(@client)
  end

  # GET /clients/new
  # Metodo que redirige a la pagina de creacion del nuevo cliente
  # Parametros de entrada: Ninguno
  # Salida: Pagina de creacion del cliente
  def new
    add_breadcrumb I18n.t('client.new'), :controller => "clients", :action => "new"
    # Se crea el cliente
    @client = Client.new
    @client.contacts.build
  end

  # GET /clients/1/edit
  # Metodo que redirige a la pagina de edicion de un cliente
  # Parametros de entrada: Id del cliente
  # Salida: Redirige a la pagina de edicion de los datos del cliente
  def edit
    # Se busca el cliente
    @client = Client.find(params[:id])
    add_breadcrumb @client.name, client_path(@client)
    add_breadcrumb I18n.t('client.edit'), :controller => "clients", :action => "edit", :id => @client.id
  end

  # POST /clients
  # Metodo que crea un cliente, y al menos, un contacto asociado a este
  # Parametros de entrada: Nombre, idioma, imagen asociada al cliente, y nombre, mail y skype de cada contacto que se quiera crear
  # Salida: Se crea el cliente y se redirige a la pagina del cliente creado
  def create
    # Se crea el cliente
    @client = Client.new(params[:client])
    # Se crean los contactos
    @client.contacts.each do |contact|
        contact.password = contact.name
        contact.language = params[:client][:language]
    end
    if @client.valid? and @client.contacts.map(&:valid?).all?
      # Se salva el cliente
      @client.save
      # Se salvan los contactos
      @client.contacts.each(&:save)
      redirect_to @client, flash: {success: I18n.t('client.create_success')}
    else
      render 'new'
    end
  end


  # PUT /clients/1
  # Metodo que actualiza los atributos de un cliente dado
  # Parametros de entrada: Id del cliente, y atributos a actualizar
  # Salida: Se redirige a la pagina del cliente cuyos datos fueron actualizados
  def update
    # Se busca el cliente
    @client = Client.find(params[:id])
    # Se actualizan los parametros
    if @client.update_attributes(params[:client])
      redirect_to @client, flash: {success: I18n.t('client.update_success')}
    else
      render 'edit'
    end
  end

  # DELETE /clients/1
  # Metodo que destruye un cliente dado
  # Parametros de entrada: Id del cliente
  # Salida: Se borra el cliente y se redirige a clients_url
  def destroy
    # Se busca el cliente
    @client = Client.find(params[:id])
    # Se destruye el cliente
    @client.destroy
    # Se redirige a clients_url
    redirect_to clients_url
  end

  # GET /my_client/1
  # Metodo que busca el cliente asociado a un contacto que se encuentra conectado
  # Parametros de entrada: Id del contacto conectado
  # Salida: Se redirige a la pagina del cliente asociado al contacto conectado
  def my_client
    # Se busca el cliente asociado al contacto
    @client = Client.find(current_user.client_id)
    add_current_to_breadcrumb @client.name
  end
end
