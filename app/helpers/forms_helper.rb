module FormsHelper

  # Metodo para generar la grafica doc de un resumen de un formulario
  # Parametros de entrada: Tabla del formulario, proyecto del cual se quiere saber el resumen del formulario
  def draw_chart(spreadsheet,project)
    quals = retrieve_data(spreadsheet,project.id)
    if not quals.empty?
      moods = mood_list
      data = GoogleVisualr::DataTable.new
      data.new_column('string')
      data.new_column('number')
      (1..5).each do |i|
        data.add_row(["#{moods[i-1]}",quals.count(i.to_s)])
      end
      option = { title: I18n.t('form.summary_results') + " " + project.name,
                 is3D: true, legend: 'left', backgroundColor: { fill: 'transparent' }
               }
      GoogleVisualr::Interactive::PieChart.new(data, option)
    end
  end

  private

  # Metodo para generar un array de estados de animo
  def mood_list
    ['angry','sad','neutral','satisfied','happy'].map{|s| I18n.t('mood.' + s)}
  end

  # Metodo para obtener los valores de un proyecto en un formulario
  # Parametros de entrada: Tabla del formulario, proyecto del cual se quiere saber el resumen del formulario
  def retrieve_data(spreadsheet,project)
    ps = project.to_s
    ans = spreadsheet.map do |r|
      match_data = r[1] && r[1].match(/(\d+)/)
      if match_data and match_data[1] == ps
        r.last
      end
    end
    ans.compact
  end

end
