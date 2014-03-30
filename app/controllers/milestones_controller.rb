class MilestonesController < ApplicationController

  before_filter :ensure_mooveit

  # GET /milestones/1/edit
  # Metodo que edita los milestones
  # Parametros de entrada: id del milestone
  # Salida: proyecto asociado al milestone
  def edit
    @milestone = Milestone.find(params[:id])
    @project = @milestone.project
  end

  # POST /milestones
  # Metodo que crea un milestone
  # Parametros de entrada: Nombre, descripcion y fecha del milestone
  # Salida: Se crea el milestone
  def create
    @milestone = Milestone.new(params[:milestone])
    @milestone.add_project(params[:project_id])
    if @milestone.save
      redirect_to project_path( @milestone.project, :tab=>'2'), flash: {project_success: I18n.t('milestone.create_success')}
    else
      redirect_to project_path( @milestone.project, :tab=>'2'), flash: {project_error: I18n.t(@milestone.errors.first.second)}
    end
  end

  # PUT /milestones/1
  # Metodo que edita un milestone
  # Parametros de entrada: id, nombre, descripcion y fecha del milestone
  # Salida: Se actualizan los datos del milestone
  def update
    @milestone = Milestone.find(params[:id])
    if @milestone.update_attributes(params[:milestone])
      redirect_to project_path( @milestone.project, :tab=>'2'), success: I18n.t('milestone.update_success')
    else
      redirect_to :back, flash: {project_error: I18n.t('milestone.error_create')}
    end
  end

  # DELETE /milestones/1
  # Metodo que borra un milestone dado
  # Parametros de entrada: Id del milestone
  # Salida: Se redirige a la vista del proyecto
  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy
    redirect_to project_path( @milestone.project, :tab=>'2'), success: I18n.t('milestone.destroy_success')
  end
end
