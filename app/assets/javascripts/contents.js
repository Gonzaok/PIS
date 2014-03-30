$(document).ready(function(){
 $('.star-rating').raty({
    score: function(){
      return $(this).attr('data-rating');
    },
    click: function(score, evt){
      var cssId = $(this).attr('id');
      //   alert(cssId.substr(16));
      var content_id = cssId.substr(16);
      $.ajax({
          type: "POST",
          url: "/contents/content_ranking",
          data:{
          id:  $(this).attr('id-project'),
          id_content: content_id,
          ranking: score
         },
         success: function(msg){
         }
      });
    }
  });

  $('span.content-date').tooltip();
  $('.editar-o-eliminar').tooltip();
});
