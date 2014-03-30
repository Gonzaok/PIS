


      function duplicateDiv(){

        var cantidad = $(".nuevo-contacto").size();

		var id_name = "client_contacts_attributes_" + (cantidad -1) + "_name";
		var name_name="client[contactos_attributes][" + (cantidad -1 ) + "]][name]";

		var id_mail = "client_contacts_attributes_" + (cantidad -1 ) + "_email";
		var name_mail="client[contacts_attributes][" + (cantidad -1 ) + "]][email]";


		var id_skype = "client_contacts_attributes_" + (cantidad -1 ) + "_skype";
		var name_skype="client[contacts_attributes][" + (cantidad -1 ) + "]][skype]";

        var dondeVa = $('.guardar-cliente:last');
        $('.otro-contacto:first').clone().insertBefore(dondeVa);
        $('.clear-all:first').insertBefore($('.guardar-cliente'));

        $('.nuevo-contacto:last').clone().insertBefore($('.otro-contacto:last').prev());
        $('.otro-contacto:first').remove();
        $('.nuevo-contacto:last').find('input:first').attr("value",""); //Se vacia el valor anterior.
        $('.nuevo-contacto:last').find('input[id=' + id_mail +']').attr("value",""); //Se vacia el valor anterior.
        $('.nuevo-contacto:last').find('input:last').attr("value",""); //Se vacia el valor anterior.
        $('.nuevo-contacto:last').find('.contact-legend:first').text("Contact #"+ (cantidad +1 )); //Se cambia el legend.

		$('.nuevo-contacto:last').find('input[id=' + id_name +']').attr('name', "client[contacts_attributes][" + cantidad + "]][name]");
		$('.nuevo-contacto:last').find('input[id*=' + id_name +']').attr('id', "client_contacts_attributes_" + cantidad + "_name");
		$('.nuevo-contacto:last').find('input[id=' + id_mail +']').attr('name', "client[contacts_attributes][" + cantidad + "]][email]");
		$('.nuevo-contacto:last').find('input[id*=' + id_mail +']').attr('id', "client_contacts_attributes_" + cantidad + "_email");
		$('.nuevo-contacto:last').find('input[id=' + id_skype +']').attr('name', "client[contacts_attributes][" + cantidad + "]][skype]");
		$('.nuevo-contacto:last').find('input[id*=' + id_skype +']').attr('id', "client[contacts_attributes][" + cantidad + "]][skype]");


















        cantidad++;
	};
