module ClientsHelper

  # Dado un cliente y un tamaño (:big o :small), esta funcion renderiza
  # la imagen del cliente en el tamaño correspondiente
  # Parametros de entrada: El cliente y el tamaño
  # Salida: Se renderiza la imagen
  def image_client(client,size)
    opts = size == :big ? {:class => "img-polaroid"} : {}
    if client.image_file_name
      image_src = image_tag client.image.url(size), opts
    else
      image_src = image_tag "missing_#{size.to_s}.png", opts
    end
    render :inline => image_src
  end

end
