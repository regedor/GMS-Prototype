jQuery.noConflict();

jQuery(document).ready(function($){
	$(".row_mark_header").click(function () {
	  var check = $(this).is(':checked');
      $(".row_mark_elem").each(function (i) {
        $(this).attr('checked',check);
     });
 });
});
