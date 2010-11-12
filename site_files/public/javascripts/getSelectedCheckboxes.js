jQuery.noConflict();

jQuery.ajaxSetup({
	'beforeSend':function(xhr) {xhr.setRequestHeader('Accept','text/javascript')}
})




jQuery(document).ready(function($){
	$(".dropdownmenu").change(do_action=function () { 
		  var action = $(".dropdownmenu option:selected").attr("value");
		  if(action != "")
		  {
		    var active_controller_url = $("#main-navigation .active a").attr("href");
		    var patt1=/\//g;
		    var active_controller = active_controller_url.split(patt1)[2];

		    var ids = "";
		    var id =""
			var ids_array = [];
		    $(".row_mark_elem").each(function() {
			  if($(this).is(':checked'))
			  {
				  id = $(this).attr("id").substring(9,10);
				  ids+= (id+"&");
				  ids_array.push(id);
			  }
		    });

			var path = active_controller_url.substring(1,active_controller_url.length)+"/do_action";


			$.post(path,{"actions": action,"ids":ids},function(data){
				if(data == "")
				{
					$(".flash").renderFlash("notifier.action_failure","error");	
					$(".dropdownmenu").bind('change',do_action);	
				}
				else
				{
					$("#wrapper #main").html(data);
					$(".flash").renderFlash("notifier.action_success","notice");	
					$(".dropdownmenu").bind('change',do_action);
				}		
			},"html");
			$(this).get(0).selectedIndex = 0;		
		  }
	    });
	});
