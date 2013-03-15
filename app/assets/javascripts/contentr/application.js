//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require contentr/overlay

jQuery(function($) {

  // setup overlay for contentr admin
  $('a[rel=contentr-overlay]').contentr_overlay({
    width: '90%',
		height: '90%',
		close: function() {
		  location.reload();
		}
  });

  // make paragraphs sortable
  $('.contentr-area').sortable({
    items: '.paragraph',
    handle: '.toolbar .handle',
    update: function(event, ui) {
      var ids = $(this).sortable('serialize');
      var current_page = $(this).closest('.contentr-area').attr('data-contentr-page');
      var area_name = $(this).closest('.contentr-area').attr('data-contentr-area');
      $.ajax({
        type: "PUT",
        url: "/contentr/admin/pages/"+current_page+"/area/"+area_name+"/paragraphs/reorder",
        data: ids,
        error: function(msg) {
          alert("Error: Please try again.");
        }
      });
    }
  });

  $(".show_published_version").click(function(){
    var clicked = $(this);
    $.ajax({
      type: "GET",
      url: "/contentr/admin/pages/"+ clicked.data('page') +"/paragraphs/"+
           clicked.data('paragraph')+"/show_version/"+ clicked.data('current'),
      success: function(msg){
        $('#paragraph_'+ clicked.data('paragraph')).find('div.contentr_paragraph_body').html(msg);
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

