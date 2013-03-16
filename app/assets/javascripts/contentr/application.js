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

  $("a[data-contentr-show-published-version]").click(function(){
    var clicked = $(this);
    var id = clicked.data("contentr-show-published-version");
    $.ajax({
      type: "GET",
      url: clicked.attr('href'),
      success: function(msg){
        $('#paragraph_' + id).find('div.contentr_paragraph_body').html(msg);
        clicked.hide();
        $('a[data-contentr-publish-version='+id+']').hide();
        $('a[data-contentr-show-unpublished-version='+id+']').show();
        $('a[data-contentr-revert-unpublished-version='+id+']').show();
      },
      error: function(msg){
        console.log("Error: "+ msg);
      }
    });
    return false;
  });

  $("a[data-contentr-show-unpublished-version]").click(function(){
    var clicked = $(this);
    var id = clicked.data("contentr-show-unpublished-version");
    $.ajax({
      type: "GET",
      url: clicked.attr('href'),
      success: function(msg){
        $('#paragraph_' + id).find('div.contentr_paragraph_body').html(msg);
        clicked.hide();
        $('a[data-contentr-revert-unpublished-version='+id+']').hide();
        $('a[data-contentr-show-published-version='+id+']').show();
        $('a[data-contentr-publish-version='+id+']').show();
      },
      error: function(msg){
        console.log("Error: "+ msg);
      }
    });
    return false;
  });

});

