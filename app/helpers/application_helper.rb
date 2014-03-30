module ApplicationHelper

  # Método que determina la opción del lenguaje
  # Parametros de entrada: Opción del lenguaje
  # Salida: Selecciona el lenuaje a mostrar en la web
  def language_opts
    Languages.map{|s| [I18n.t("language.#{s}"),s] }
  end

  # Método que imprime los últimos errores que ocurrieron
  # Parametros de entrada: Array de errores a imprimir
  # Salida: Se muestran los errores en pantalla
  def printErrors(errorer,no_translation=nil)
	  if errorer and not errorer.errors.empty?
        tags = '
          <div class="message_box">
            <div class="message">
              <div class="alert alert-error">
                <button class="close" data-dismiss="alert" type="button">x</button>'

        if errorer.errors.size == 1
          attr, msg = errorer.errors.first
          tags += (no_translation ? msg : I18n.t(msg))
        else
          tags += '<ul>'
          errorer.errors.each do |attr, msg|
          tags += '<li>'+ (no_translation ? msg : I18n.t(msg)) + '</li>'
        end
          tags += '</ul>'
        end

        tags += '
              </div>
            </div>
          </div>'

        render :inline => tags
	  end
  end

end
