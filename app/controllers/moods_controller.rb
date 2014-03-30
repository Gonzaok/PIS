class MoodsController < ApplicationController

  before_filter :ensure_user, :except => :update
  # GET /moods
  # Metodo que lista los moods
  # Parametros de entrada: Ninguno
  # Salida: Lista de moods
  def index
    @moods = Mood.all
  end

  # GET /moods/1
  #def show
  #  @mood = Mood.find(params[:id])
  #end

  # GET /moods/new
  # Metodo que muestra la pagina new del mood, para poder crear un mood nuevo
  # Parametros de entrada: Ninguno
  # Salida: Pagina new de mood
  def new
    @mood = Mood.new
  end

  # GET /moods/1/edit
  def edit
    @mood = Mood.find(params[:id])
  end

  # POST /moods
  # Metodo que crea un mood nuevo
  # Parametros de entrada: mood, comentario e id del proyecto
  # Salida: Se crea el mood asociado al proyecto y se redirige a la pagina show del proyecto
  def create
    @mood = Mood.new(:mood => params[:mood], :comment => params[:comment][0])
    @mood.add_user(current_user)
    @mood.add_project(params[:id_project])
    if @mood.save
      redirect_to @mood.project, flash: {success: I18n.t('mood.create_success')}
    else
      redirect_to @mood.project, flash: {error: I18n.t('mood.create_error')}
    end
  end

  # PUT /moods/1
  # Metodo que edita un mood
  # Parametros de entrada: id del mood, mood y comentario
  # Salida: Se actualizan los datos del mood
  def update
    @mood = Mood.find(params[:id])

    if @mood.update_attributes(params[:mood])
      redirect_to @mood.project, flash: {success: I18n.t('mood.update_success')}
    else
      redirect_to @mood.project, flash: {error: I18n.t('mood.create_error')}
    end
  end

  # DELETE /moods/1
  # Metodo que borra un mood dado
  # Parametros de entrada: Id del mood
  # Salida: Se redirige a moods_url
  def destroy
    @mood = Mood.find(params[:id])
    @mood.destroy
    redirect_to moods_url
  end

end
