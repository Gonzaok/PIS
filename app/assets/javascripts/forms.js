$(function () {
		$('.focus-datepicker').datepicker();
      $('#focus-typeahead').typeahead({
        source: function (typeahead, query) {
          return ["Numerex", "Loterias y Quinielas", "Conde Nast", "Google", "Yahoo", "Moove-It", "Microsoft", "Globant", "Mercadolibre, Inc."]
          }
      });
	})


$(document).ready(function() {

  $('#form_send_projects').attr("disabled","disabled");
  $('#form_summary_projects').attr("disabled","disabled");

  $('#form_send_clients').change(function(){

      var id = $('#form_send_clients').val();

      //delete old data
      $('#form_send_projects').children().remove()

      if (id == "")
      {
        $('#form_send_projects').attr("disabled","disabled");
        return;
      }

      $.ajax({
          type: "GET",
          url: "/forms/get_projects",
          data: { 'id':id},
          success: function(data) {

            //set date to select project
            $('#form_send_projects').removeAttr("disabled");
            $('#form_send_projects').append('<option value="" selected="selected"></option>');
            for (var i = 0; i < data.length; i++) {
              $('#form_send_projects').append('<option value='+data[i].id+' >'+data[i].name+'</option>');
            }

          },
      });

  });

  $('#form_summary_clients').change(function(){

      var id = $('#form_summary_clients').val();

      //delete old data
      $('#form_summary_projects').children().remove()

      if (id == "")
      {
        $('#form_summary_projects').attr("disabled","disabled");
        return;
      }

      $.ajax({
          type: "GET",
          url: "/forms/get_projects",
          data: { 'id':id},
          success: function(data) {

            //set date to select project
            $('#form_summary_projects').removeAttr("disabled");
            $('#form_summary_projects').append('<option value="" selected="selected"></option>');
            for (var i = 0; i < data.length; i++) {
              $('#form_summary_projects').append('<option value='+data[i].id+' >'+data[i].name+'</option>');
            }

          },
      });

  });



});
