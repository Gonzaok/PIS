module ProjectsHelper

  # Metodo que muestra en la pagina show del proyecto, el estado de animo actual en tamaño grande
  # Parametros de entrada: El proyecto a mostrar
  # Salida: Se muestra la imagen correspondiente al ultimo estado de animo seteado por el cliente
  def show_mood(project,large=nil)
    # Se busca el ultimo estado de animo seteado por el cliente
    mood = Mood.find(:last, :conditions => {:project_id => project.id} )
    # Si nunca se seteo un estado de animo, se muestra el contento
    if !mood
      face = 'happy'
    else
      face = mood.mood
      face = face.downcase
    end
    # Se muestra en el show.html el estado de animo
    render :inline => '<img src="/assets/' + face + (large == :large ? '-lrg' : '') + '.png " title="' + I18n.t("mood."+face) + '" alt="' + I18n.t("mood."+face) + '" />'
  end

  # Metodo que muestra en la pagina show.html del proyecto, el comentario asociado al ultimo estado de animo seteado por el cliente
  # Parametros de entrada: El proyecto a mostrar
  # Salida: Se muestra el texto correspondiente al comentario del ultimo estado de animo
  def show_comment_mood(project)
    # Se busca el ultimo estado de animo seteado para el proyecto a mostrar
    mood = Mood.find(:last, :conditions => {:project_id => project.id} )
    # Si existe y no es vacio, se muestra dicho comentario
    if mood and (mood.comment != "")
      render :text => mood.comment
    end
  end

  # Muestra los contenidos del proyecto en la pagina show.html.
  # Para cada contenido se ve si el usuario actual es contacto, moove-it o administrador para ver cual de estos listar;
  # ya que los contenidos tienen un parametro de filtro de contenidos
  # Parametros de entrada: El proyecto a mostrar
  # Salida: La lista de contenidos dependientes del tipo de usuario
  def contents(project)
    # Se crea un hash de condiciones para hacer la busqueda de contenidos
    cond = Hash[:project_id => project.id]
    # Se obtiene el usuario conectado
    us = User.find(session[:user_id])
    # Si es contacto se setea la condicion de acceso a clientes
    cond[:access_client] = true if us.class == Contact
    # Si es administrador se setea la condicion de acceso a administrador o usuario moove-it
    cond[:access_moove_it] = true if us.class != Contact and !us.is_admin
    # Se buscan los contenidos, asociados al proyecto dado, que cumples las condiciones dadas anteriormente
    Content.find(:all, :conditions => cond, :order => 'created_at desc')
  end

  # Metodo que muestra la grafica de evolucion de estados en funcion del tiempo
  # Paramentros de entrada: Ninguno
  # Salida: Muestra la grafica en la pagina show.html del proyecto
  def show_chart
    render :partial => 'charts', :project => @project
  end

  def show_moods(project)
    total_moods = project.moods.count + 1
    images = ['happy','satisfied','neutral','sad','angry']
    total = images.map{|s| project.moods.where(:mood => s).count}
    total[0] += 1

    view=""
    5.times do |i|
      percentage = (total[i]* 100)/total_moods
      case percentage
      when 1...33
        view+='<img src="/assets/' + images[i]+ '-sml.png " title="' + images[i]+ '" alt="' + images[i]+ '" /> <br/><br/>'
      when 33...66
        view+='<img src="/assets/' + images[i]+ '.png " title="' + images[i]+ '" alt="' + images[i]+ '" /> <br/></br/>'
      when 66..100
        view+='<img src="/assets/' + images[i]+ '-lrg.png " title="' + images[i]+ '" alt="' + images[i]+ '" /> <br/><br/>'
      end
    end
    render :inline => view
  end

end
