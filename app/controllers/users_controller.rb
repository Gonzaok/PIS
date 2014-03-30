class UsersController < ApplicationController

  before_filter :init, :except => [:new_contact, :edit_contact, :create_contact, :show]
  before_filter :ensure_user
  before_filter :ensure_admin, :only => [:toggle_admin, :destroy]
  before_filter :ensure_mooveit, :except => [:edit_profile, :update_profile]

  # Agrega el breadcrumb del indice de usuarios
  def init
    add_breadcrumb I18n.t('user.users'), users_path
  end

  # GET /users
  # Metodo que muestra todos los usuarios Moove-it en la pagina index.html
  # Parametros de entrada: Ninguno
  # Salida: Lista de todos los usuarios moove-it
  def index
    @users = MooveitUser.all
  end

  # GET /users/1
  # Metodo que muestra la pagina show.html de un usuario seleccionado
  # Parametros de entrada: Id del usuario
  # Salida: Lista todos los datos del usuario
  def show
    # Busca el usuario identificado por id
    @user = User.find(params[:id])
    # Agrega un breadcrumb con el nombre del cliente
    @user.instance_of?(Contact) ?  add_breadcrumb(I18n.t('client.clients'), clients_path) : init
    add_breadcrumb @user.client.name, client_path(@user.client) if @user.instance_of? Contact
    add_breadcrumb @user.name, user_path(@user)
  end

  # Metodo que cambia el tipo de usuario de administrador a usuario moove-it o viceversa
  # Parametros de entrada: Id del usuario
  # Salida: Se le cambia el tipo de usuario de administrador a moove-it o viceversa
  def toggle_admin
    # Se busca el usuario por el id
    @user = User.find(params[:id])
    # Se cambia el tipo de usuario
    @user.is_admin = !@user.is_admin
    # Se guarda el usuario
    @user.save
    # Se redirige a users_url
    redirect_to users_url
  end

  # Metodo que redirige a la pagina edit del perfil de el usuario conectado
  # Parametros de entrada: Ninguno
  # Salida: Muestra la pagina de edit de perfil del usuario, con los campos permitidos para modificar
  def edit_profile
    @user = current_user
    add_current_to_breadcrumb I18n.t('user.change_profile')
  end

  # Metodo que redirige a la pagina edit de un contacto
  # Parametros de entrada: Id del contacto a editar
  # Salida: Muestra la pagina de edit del contacto, con los campos permitidos para modificar
  def edit_contact
    # Busca el contacto a editar
    @user = User.find(params[:id])
    # Agrega un breadcrumb con el nombre del cliente
    add_breadcrumb I18n.t('client.clients'), clients_path
    add_breadcrumb @user.client.name, client_path(@user.client)
    add_breadcrumb @user.name, user_path(@user)
    add_current_to_breadcrumb I18n.t('contact.edit')
  end

  # Metodo que crea un nuevo usuario moove-it
  # Parametros de entrada: email, name, skype, password, password_confirmation, language
  # Salida: Se crea un nuevo usuario moove-it y se redirige a users_url
  def create
    # Se crea el usuario moove-it con los datos pasados por parametros
    @user = MooveitUser.new(params[:user])
    # Si se puede salvar, se redirige al users_url con un mensaje de exito
    if @user.save
      redirect_to users_url, flash: {success: I18n.t('user.create_success')}
    else
      # Si no se puede salvar, se redirige a la pagina de edit
      redirect_to :back
    end
  end

  # Metodo que dirige a la pagina de creacion de un nuevo contacto, asociado a un cliente ya creado
  # Parametros de entrada: Id del cliente al que se quiere asociar el nuevo contacto
  # Salida: Se redirige a la pagina de creacion del contacto
  def new_contact
    # Se crea un nuevo contacto
    @user = Contact.new
    # Se le asigna el id del cliente al nuevo contacto
    @user.client_id = params[:id]
    @client = Client.find(params[:id])

    # Se agregan los breadcrumbs correspondientes
    add_breadcrumb I18n.t('client.clients'), :controller => "clients", :action => "index"
    add_breadcrumb @client.name, client_path(@client)
    add_current_to_breadcrumb I18n.t('contact.add_new')
  end

  # Metodo que crea un contacto a partir de los datos pasados por parametro
  # Parametros de entrada: email, name, skype, password, password_confirmation, language
  # Salida: Se crea un nuevo contacto y se redirige a la pagina show.html del cliente asociado al nuevo contacto
  def create_contact
    # Se crea el nuevo contacto con los datos pasados por parametro
    @user = Contact.new(params[:contact].merge Hash[:password => params[:contact][:name]])
    # Si se salva correctamente, se redirige a la pagina show.html del cliente asociado al nuevo contacto
    # Sino, se vuelve a la pagina anterior indicando el mensaje de error correspondiente
    if @user.save
      redirect_to :controller => "clients", :action => "show", :id => params[:contact][:client_id]
    else
      @client = Client.find(params[:contact][:client_id])
      add_breadcrumb I18n.t('client.clients'), :controller => "clients", :action => "index"
      add_breadcrumb @client.name, client_path(@client)
      add_current_to_breadcrumb I18n.t('contact.add_new')
      render 'new_contact'
    end
  end

  # Metodo que actualiza los datos de un usuario, a partir de los datos pasados por parametro
  # Parametros de entrada: Los parametros que se quieran actualizar
  # Salida: Se redirige a la pagina edit_profile
  def update_profile
    # Se fija si el usuario es de tipo Moove-it o Contacto
    if current_user.instance_of? MooveitUser
      type = :mooveit_user
    else
      type = :contact
    end
    # Chequea que parametros van a ser actualizados y los guarda
    # En caso de error redirige a la pagina de modificar perfil con el mensaje de error correspondiente
    if (params[type][:current_password] != "") || (params[type][:password] != "") || (params[type][:password_confirmation] != "")
      if User.authenticate(current_user.email, params[type][:current_password])
       if params[type][:password].empty?
          flash[:error] = I18n.t('user.empty_password')
          render 'edit_profile'
        else
          if current_user.update_attributes(params[type].except(:current_password))
            I18n.locale = params[type][:language]
            flash[:success] = I18n.t('user.update_success')
            redirect_to :action => "edit_profile", :locale => I18n.locale
          else
            render 'edit_profile'
          end
        end
      else
        flash[:error] = I18n.t('user.incorrect_password')
        redirect_to :action => "edit_profile"
      end
    else
      if current_user.update_attributes(params[type].except(:password, :current_password, :password_confirmation))
        I18n.locale = params[type][:language]
        flash[:success] = I18n.t('user.update_success')
        redirect_to :action => "edit_profile", :locale => I18n.locale
      else
        render 'edit_profile'
      end
    end
  end

  # Metodo que actualiza los datos de un contacto
  # Parametros de entrada: Los atributos a ser modificados
  # Salida: Redirige a la pagina del contacto con un mensaje de exito
  def update_contact
    # Busca el contacto con el id pasado por parametro
    @contact = User.find(params[:id])
    # Actualiza los datos del contacto, en caso de exito, redirige a la pagina del contacto
    # En caso de error, redirige a la pagina anterior con el mensaje de error correspondiente
    if @contact.update_attributes(params[:contact])
      redirect_to @contact.client, flash: {success: I18n.t('user.update_success')}
    else
      redirect_to :back, flash: {error: I18n.t('user.error_update')}
    end
  end

  # DELETE /users/1
  # Metodo que borra un usuario seleccionado
  # Parametros de entrada: Id del usuario
  # Salida: Se borra el usuario y se redirige a users_url
  def destroy
    # Se busca el usuario por el id
    @contact = User.find(params[:id])
    # Se destruye el usuario
    @contact.destroy
    # Se redirige a users_url
    redirect_to users_url
  end

  # Metodo que lista todas las actividades
  # Parametros de entrada: Ninguno
  # Salida: Devuelve una lista con todas las actividades
  def activity_list
    @list = (Comment.all + Content.all + Mood.all + Project.all + Milestone.all + Form.all + Client.all + Contact.all).sort_by {|x| x[:updated_at]}.reverse
  end

end
