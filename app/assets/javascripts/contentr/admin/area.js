jQuery(function($) {  
  $(".show_published_version").click(function(){
    var clicked = $(this);
    $.ajax({
      type: "GET",
      url: "/contentr/admin/pages/"+ clicked.data('page') +"/paragraphs/"+
           clicked.data('paragraph')+"/show_version/"+ clicked.data('current'),
      success: function(msg){
        $('#paragraph_'+ clicked.data('paragraph')+' div:last').html(msg);
        if(clicked.data("current") == "0"){
          clicked.text("Show unpublished version");
          clicked.data("current", "1");
          $("#publish-btn-"+ clicked.data('paragraph')).hide();
          $("#revert-btn-"+ clicked.data('paragraph')).show();
        }else{
          clicked.text("Show published version");
          $("#publish-btn-"+ clicked.data('paragraph')).show();
          $("#revert-btn-"+ clicked.data('paragraph')).hide();
          clicked.data("current", "0");
        }

      },
      error: function(msg){
        console.log("Error: "+ msg);
      }
    });
  });
});
