module MoodsHelper

  # Método que realiza el cálculo del balance general de estados de proyectos para mostrar en el home
  # Parametros de entrada: Una colección de todos los proyectos
  # Salida: Balance general de estados
  def mood_balance
    size = Project.all.size
    total = 0.0
    value = 0
    Project.all.each do |p|
      if p.moods != []
        if p.moods.last.mood == "Happy"
          total = total + 4.0
        end
        if p.moods.last.mood == "Satisfied"
          total = total + 3.0
        end
        if p.moods.last.mood == "Neutral"
          total = total + 2.0
        end
        if p.moods.last.mood == "Sad"
          total = total + 1.0
        end
      else
        total = total + 4.0
      end
    end
    if size > 0
      value = ((total/size) * 25)
    end
    render :inline => value.round(2).to_s
  end

  # Método que confirma si un usuario logueado es contacto a través de la sesión actual
  # Parametros de entrada: Id del usuario
  # Salida: Booleano que determina si es contacto o no
  def is_contact?
    User.find(session[:user_id]).instance_of? Contact
  end

end