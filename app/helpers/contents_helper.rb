module ContentsHelper

  # Permite modificar las visibilidades de los contenidos
  def user_contact?(us, x, p)
    check = '<i class="icon-ok-circle"></i>'
    uncheck = '<i class="icon-ban-circle"></i>'
    link  = Proc.new do |name,sym|
        '<%= link_to :controller => "contents", :action => "modify_visibility", :id => ' + x.id.to_s + ', :vis => :' +  sym.to_s + ' do %>' +
        (x.send(sym) ? check : uncheck) + ' ' + name + '<% end %>'
    end

    render :inline => '
      <div class="btn-group pull-left">
        <a class="btn dropdown-toggle btn-mini" data-toggle="dropdown" href="#">
          <i class="icon-lock"></i>
          <span class="caret"></span>
        </a>
        <ul class="dropdown-menu">
          <li>'+link.call(I18n.t('visibility.client'),:access_client)+'</li>
          <li>'+link.call(I18n.t('visibility.staff'),:access_moove_it)+'</li>
        </ul>
      </div>'
  end

  # Permite setear ranking a contenidos si el usuario logueado es admin
  def star_ranking(x)
    if User.find(session[:user_id]).is_admin?
      render :inline => '
        <%= javascript_include_tag "contents" %>
        <div class="row">
          <div class="pull-right">
            <div class="star-rating" id="start-content-1_' + x.id.to_s + '" data-rating="' + x.ranking.to_s + '" id-project="<%=@project.id%>"></div>
          </div>
        </div>'
    end
  end


  def star_ranking_static(x)
    good = '<img src="/assets/star-on.png">'
    bad = '<img src="/assets/star-off.png">'
    render :inline => '
      <div class="row">
        <div class="pull-right">
          <div style="width:100px;">'+
            good*x.ranking + bad*(5-x.ranking) +
          '</div>
        </div>
      </div>'
  end

end
