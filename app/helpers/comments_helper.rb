module CommentsHelper

  # Devuelve la cantidad de comentarios sobre un contenido
  def comment_count(content)
    content.comments.size
  end

  # Devuelve una lista de largo num de comentarios del contenido dado
  def list_comments(content,num)
    @comments = Comment.find(:all, :limit => num, :order=> 'created_at asc', :conditions => { :content_id => content} )
  end

  # Devuelve una lista con todos los comentarios del contenido dado
  def list_all(content)
    @comments = Comment.find(:all, :order=> 'created_at asc', :conditions => { :content_id => content} )
  end

  # Devuelve true si el comentario pertenece al usuario actual y la fecha de creación del comentario es mayor a (Time.now.getgm - 60*30)
  def check_date(comm)
    (comm.created_at > (Time.now.getgm - 60*30) and comm.user_id == session[:user_id])
  end

end