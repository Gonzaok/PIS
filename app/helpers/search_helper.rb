require 'digest/md5'

module SearchHelper

  # Metodo que calcula la cantidad de resultados encontrados
  # Parametros de entrada: Tiempo, Lista de proyectos, clientes, usuarios y contenidos
  # Salida: Total de elementos encontrados
  def results(time,*args)
    total = args.inject(0){|a,s| a + (s && s.size || 0)}
    render :inline => I18n.t('search.result', :total => total.to_s, :time => time.round(4))
  end

  # Link para los users, para ser usada en la barra de búsqueda
  # Parámetros de entrada: Un usuario y el tamaño para la imagen
  # Salida: Una string conteniendo el link para ese usuario.
  def get_gravatar_url(user,size)
    email_address = user.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "http://www.gravatar.com/avatar/#{hash}?size=#{size}"
  end

  # Parseo del resumen de un contenido, para ser mostrado en la barra de búsqueda.
  # Parámetros de entrada: Un string resumen y la query objetivo
  # Salida: Un string conteniendo el trozo del resumen a ser mostrado.
  def content_part(summary,query)
    q = query[0..24]
    len = 12 - q.length / 2
    match_data = summary.match(/^(.*?)?(.{0,#{len}}#{q}.{0,#{len}})(.*?)?$/i)
    ans = match_data[2]
    ans = '..' + ans if match_data[1] and !match_data[1].empty?
    ans += '..' if match_data[3] and !match_data[3].empty?
    ans
  end

end
