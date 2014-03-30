require 'digest/md5'

module SessionsHelper

  # Método que obtiene el gravatar de un usuario
  # Parametros de entrada: Email del usuario y tamaño de imagen deseado
  # Salida: Imagen de gravatar del usuario
  def get_gravatar(user,size)
    email_address = user.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "http://www.gravatar.com/avatar/#{hash}?size=#{size}"
    render :inline => '<img src="' + image_src + '" class="img-rounded pull-left mini-profile-pic" alt="Gravatar user.email.downcase" />'
  end

  # Método que obtiene un rounded gravatar de un usuario
  # Parametros de entrada: Email del usuario y tamaño de imagen deseado
  # Salida: Imagen de gravatar del usuario
  def get_rounded_gravatar(user,size)
    if user != nil
    	email_address = user.email.downcase
      hash = Digest::MD5.hexdigest(email_address)
      image_src = "http://www.gravatar.com/avatar/#{hash}?size=#{size}"
    else
       image_src = "http://www.gravatar.com/avatar/64e1b8d34f425d19e1ee2ea7236d3028?size=25"
    end
    render :inline => '<img src="' + image_src + '" class="img-circle pull-left mini-profile-pic" alt="Gravatar user.email.downcase" />'
  end

end
