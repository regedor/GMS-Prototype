jQuery.noConflict();

jQuery.ajaxSetup({
	'beforeSend':function(xhr) {xhr.setRequestHeader('Accept','text/javascript')}
})

jQuery(document).ready(function($){
	$(".dropdownmenu").change(function () {
		  var action = $(".dropdownmenu option:selected").attr("value");
		  if(action != "")
		  {
		    var active_controller_url = $("#main-navigation .active a").attr("href");
		    var patt1=/\//g;
		    var active_controller = active_controller_url.split(patt1)[2];
          
		    var ids = [];
		    $(".row_mark_elem").each(function() {
			  if($(this).is(':checked'))
			  {
				  ids.push($(this).attr("id").substring(9,10));
			  }
		    });
		
		    alert(action+' '+ids);
		    $(this).get(0).selectedIndex = 0;
			
			//FIXME Ajax post
			var path = "http://localhost:3000/admin/admin/users/active"
		    $.post(path,{ "actions": action},null,"script");
		  }
        });
 });