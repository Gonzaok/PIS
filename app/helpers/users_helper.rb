module UsersHelper

  # Metodo que obtiene el nombre de un usuario seleccionado
  # Parametros de entrada: Id del usuario
  # Salida: Nombre del usuario
	def user_name(id)
	  # Busca el usuario a partir del id pasado por parametro
		User.find_by_id(id).name
	end

  # Metodo que obtiene las actividades recientes realizadas en Focus
  # Parametros de entrada: Ninguno
  # Salida: Lista de todas las actividades
	def recent_activity
		(Comment.all + Content.all + Mood.all + Project.all + Milestone.all + Form.all + Client.all + Contact.all).sort_by {|x| x[:updated_at]}.reverse
	end

  # Metodo que selecciona una actividad
  # Parametros de entrada: Lista con las actividades seleccionadas
  # Salida:
	def select_activity(list)
		if !(list.instance_of? Project) && !(list.instance_of? Milestone) && !(list.instance_of? Form) && !(list.instance_of? Client) && !(list.instance_of? Contact)
			if list.user != nil
				if list.user.type != "Contact"
					utag = '<p><strong>'+list.user.name+'</strong> '
				else
					utag = '<p><strong>'+list.user.name+'</strong> (<a href="/clients/'+list.user.client.id.to_s+'" class="clientLink">'+list.user.client.name+'</a>) '
				end
			else
				utag = '<p><strong>'+t('contact.old')+'</strong> '
			end
		end
		if list.updated_at.day == Date.current.day
			to_print = "Hoy " + list.updated_at.strftime("%H:%M").to_s
		else
		  if list.updated_at.day + 1 == Date.current.day
			  to_print = "Ayer " + list.updated_at.strftime("%H:%M").to_s
		  else
			  to_print = list.updated_at.strftime("%b %d").to_s
		  end
		end
		if (list.instance_of? Mood)
			if list.mood == "Happy"
      	facemood = ' <i class="face-veryhappy"></i> '
    	elsif list.mood == "Satisfied"
    		facemood = ' <i class="face-happy"></i> '
    	elsif list.mood == "Neutral"
    		facemood = ' <i class="face-neutral"></i> '
    	elsif list.mood == "Sad"
    		facemood = ' <i class="face-sad"></i> '
    	else
    		facemood = ' <i class="face-angry"></i> '
      end
		end
		if list.updated_at == list.created_at
      case list
				when Comment
					render :inline => utag+t('comment.cup')+' <a href="/projects/'+list.content.project.id.to_s+'"
		    		class="projectLink">'+ list.content.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Content
	    		render :inline => utag+t('content.cup')+ ' ' +list.content_type+' ' + t('content.oncup') +' <a href="/projects/'+list.project.id.to_s+'"
		    		class="projectLink">'+ list.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Mood
	    		render :inline => utag+t('mood.cup')+ facemood + t('mood.oncup') + ' ' + '<a href="/projects/'+list.project.id.to_s+'"
		    		class="projectLink">'+ list.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Project
	    		render :inline => '<p>' + t('project.pup')+ ' <a href="/projects/'+list.id.to_s+'"
		    		class="projectLink">'+ list.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Milestone
	    		render :inline => '<p>' + t('milestone.mup')+' <a href="/projects/'+list.project.id.to_s+'"
		    		class="projectLink">'+ list.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Form
	    		render :inline => '<p>' + t('form.fup')+' <a href="' + list.admin_url + '" class="projectLink">'+ list.title+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Client
	    		render :inline => '<p>' + t('client.cup')+ ' <a href="/clients/'+list.id.to_s+'"
		    		class="clientLink">'+ list.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		    when Contact
	    		render :inline => '<p>' + t('contact.cup')+' <strong>'+list.name + ' </strong>' + t('contact.toc') +' <a href="/clients/'+list.client.id.to_s+'"
		    		class="clientLink">'+ list.client.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
	    end
    else
	    if list.instance_of? Client
	    	render :inline => t('client.cmod')+ ' <a href="/clients/'+list.id.to_s+'"
		    	class="clientLink">'+ list.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
		  elsif list.instance_of? Contact
    		render :inline => t('contact.cmod')+' <strong>'+list.name + ' </strong>' + t('contact.ctoc') +' <a href="/clients/'+list.client.id.to_s+'"
	    		class="clientLink">'+ list.client.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
    	elsif list.instance_of? Milestone
    		render :inline => t('milestone.mmod')+' <a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
    	elsif list.instance_of? Content
    		render :inline => utag+t('content.cmod')+ ' ' +list.content_type+' ' + t('content.oncup') +' <a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
    	elsif list.instance_of? Comment
				render :inline => utag+t('comment.cmod')+' <a href="/projects/'+list.content.project.id.to_s+'"
		    	class="projectLink">'+ list.content.project.name+'</a> <span class="activity-date">- ' + to_print + '</span></p>'
    	end
		end
	end

  # Metodo que selecciona una actividad para enviar en el mail
  # Parametros de entrada: Lista de actividades y cliente al que se le enviara el mail
  # Salida:
  def select_activity_for_mail(list, cli)
    if !(list.instance_of? Project) && !(list.instance_of? Milestone) && !(list.instance_of? Form) && !(list.instance_of? Client) && !(list.instance_of? Contact)
      if list.user.type != "Contact"
        utag = '<p><strong>'+list.user.name+'</strong> '
      else
        utag = '<p><strong>'+list.user.name+'</strong> (<a href="/clients/'+list.user.client.id.to_s+'" class="clientLink">'+list.user.client.name+'</a>) '
      end
    end
		if list.updated_at.day == Date.current.day
			to_print = "Hoy " + list.updated_at.strftime("%H:%M").to_s
		else
			if list.updated_at.day + 1 == Date.current.day
				to_print = "Ayer " + list.updated_at.strftime("%H:%M").to_s
			else
				to_print = list.updated_at.strftime("%b %d").to_s
			end
		end
		if (list.instance_of? Mood)
			if list.mood == "Happy"
      	facemood = " " + I18n.t('mood.happy') + " "
    	elsif list.mood == "Satisfied"
    		facemood = " " + I18n.t('mood.satisfied') + " "
    	elsif list.mood == "Neutral"
    		facemood = " " + I18n.t('mood.neutral') + " "
    	elsif list.mood == "Sad"
    		facemood = " " + I18n.t('mood.sad') + " "
    	else
    		facemood = " " + I18n.t('mood.angry') + " "
      end
		end
		if list.updated_at > 7.days.ago
			if list.updated_at == list.created_at
				if (list.instance_of? Comment) && (cli.projects.find_by_id(list.content.project.id.to_s))
					@was_activity = true
					render :inline => utag+t('comment.cup')+' <a href="/projects/'+list.content.project.id.to_s+'"
		    		class="projectLink">'+ list.content.project.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Content) && (cli.projects.find_by_id(list.project.id.to_s))
	    		@was_activity = true
	    		render :inline => utag+t('content.cup')+ ' ' +list.content_type+' ' + t('content.oncup') +' <a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Mood) && (cli.projects.find_by_id(list.project.id.to_s))
	    		@was_activity = true
	    		render :inline => utag+t('mood.cup')+ facemood + t('mood.oncup') + ' ' + '<a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activityDate">- ' + to_print + '</p>'
	    	elsif (list.instance_of? Project) && (cli.projects.find_by_id(list.id.to_s))
	    		@was_activity = true
	    		render :inline => t('project.pup')+ ' <a href="/projects/'+list.id.to_s+'"
	    		class="projectLink">'+ list.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Milestone) && (cli.projects.find_by_id(list.project.id.to_s))
	    		@was_activity = true
	    		render :inline => t('milestone.mup')+' <a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Client) && (list.id == cli.id)
	    		@was_activity = true
	    		render :inline => t('client.cup')+ ' <a href="/clients/'+list.id.to_s+'"
	    		class="clientLink">'+ list.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Contact) && (list.client.id == cli.id)
	    		@was_activity = true
	    		render :inline => t('contact.cup')+' <strong>'+list.name + ' </strong>' + t('contact.toc') +' <a href="/clients/'+list.client.id.to_s+'"
	    		class="clientLink">'+ list.client.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	end
	    else
		    if (list.instance_of? Client) && (list.id == cli.id)
		    	@was_activity = true
		    	render :inline => t('client.cmod')+ ' <a href="/clients/'+list.id.to_s+'"
		    	class="clientLink">'+ list.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
				elsif (list.instance_of? Contact) && (cli.contacts.find(list.id))
	    		@was_activity = true
	    		render :inline => t('contact.cmod')+' <strong>'+list.name + ' </strong>' + t('contact.ctoc') +' <a href="/clients/'+list.client.id.to_s+'"
	    		class="clientLink">'+ list.client.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Milestone) && (cli.projects.find_by_id(list.project.id.to_s))
	    		@was_activity = true
	    		render :inline => t('milestone.mmod')+' <a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Content) && (cli.projects.find_by_id(list.project.id.to_s))
	    		@was_activity = true
	    		render :inline => utag+t('content.cmod')+ ' ' +list.content_type+' ' + t('content.oncup') +' <a href="/projects/'+list.project.id.to_s+'"
	    		class="projectLink">'+ list.project.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	elsif (list.instance_of? Comment) && (cli.projects.find_by_id(list.content.project.id.to_s))
					@was_activity = true
					render :inline => utag+t('comment.cmod')+' <a href="/projects/'+list.content.project.id.to_s+'"
	    		class="projectLink">'+ list.content.project.name+'</a> <span class="activityDate">- ' + to_print + '</p><br>'
	    	end
			end
		end
  end
end
