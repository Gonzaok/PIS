$(document).ready(function(){
  $("#flip2").click(function(){
    $("#panel2").slideToggle("slow");
  });
});

$(document).ready(function(){
  $("#flip3").click(function(){
    $("#panel3").slideToggle("slow");
  });
});

$(document).ready(function(){

  $('.img-pencil-comment').click(function(){
    var comment_div = $(this).parent().find(".comment-content");
    var comment_text = comment_div.text().trim();
    comment_div.html('<textarea class="modified-input-comment" id="edit-comment-text" type="text">'+ comment_text +' </textarea>');
    $(this).after('<div class="pull-right" style="width:20%"><input class="btn btn-inverse pull-right" id="save-comment-btn" type="submit" value="Save"></br></br><b class="cancel-edit-comment pull-right">Cancelar</b></div>');
    $(this).after('<p class="original-comment" style="display:none">' + comment_text + '</p>');
    $(this).hide();
    $(this).parent().find(".img-remove-comment").hide();
  });


  $('.cancel-edit-comment').live("click", function(){
    $(this).parent().next().next().children().remove();

    var original = $(this).parent().prev().text();
    $(this).parent().next().next().text(original);
    //delete tag p with class = original-comment
    $(this).parent().prev().remove();

    $(this).parent().parent().find(".img-pencil-comment").show().css("display","");
    $(this).parent().parent().find(".img-remove-comment").show().css("display","");
    $(this).parent().fadeOut().remove();
  });

  $('#save-comment-btn').live("click", function(){
    var comment_textarea = $(this).parent().parent().find("#edit-comment-text");
    var comment_text = comment_textarea.val();
    var comment_id = $(this).parent().parent().find(".comment-id").val();
    var original_comment = $(this).parent().parent().find(".comment-content");

    if (comment_text == "") {
      $('.message_box:last').children().remove();
      $('.message_box:last').append('<div class="message" tabindex="1" style="outline:none"><div class="alert alert-error"><button class="close" data-dismiss="alert" type="button" onclick="$(\'#save-comment-btn\').focus()">x</button>'+ $('#empty_comment').val() + '</div></div>');
      $('.message').focus();
      return;
    }

    $.ajax({
      type: "POST",
      url: "/comments/update",
      data: { 'comment':comment_text , 'id':comment_id},
    });

    $(this).parent().parent().find(".original-comment").remove();
    comment_textarea.fadeOut().remove();
    original_comment.text(comment_text).fadeIn();
    $(this).parent().parent().find(".img-pencil-comment").show().css("display","");
    $(this).parent().parent().find(".img-remove-comment").show().css("display","");
    $(this).parent().fadeOut().remove();
  });

  $('.img-remove-comment').live("click", function(){

    var r=confirm($('#delete_comment').val());
    if (r==true){

      //cambia el valor del link "Ver Comentarios(X)
      var str = $(this).parent().parent().parent().parent().prev().prev().find('.see_comments').text();
      var patt1 = /\d+/i;
      var number = str.match(patt1);
      var newText = str.replace(number.toString(),(number-1).toString());
      $(this).parent().parent().parent().parent().prev().prev().find('.see_comments').text(newText);


      var comment_id = $(this).parent().find(".comment-id").val();
      $(this).parent().hide();

      $.ajax({
        type: "DELETE",
        url: "/comments/destroy",
        data: {'id':comment_id},
      });

    }

  });


  $('.see_comments').click(function() {
      var comment_container = $(this).parent().parent().parent().next().next().find(".comment_container");
      comment_container.toggle(1000);
  });

  $('.img_pencil').click(function() {
      $(this).parent().prev().toggle(500);
  });

  $('.close_edit_comment').click(function() {
      $(this).parent().toggle(1000);
  });

  $('.close_modificarCont').click(function() {
      $(this).parent().parent().parent().parent().toggle(500);
  })

});
