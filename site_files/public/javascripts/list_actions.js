jQuery.noConflict();

//jQuery.ajaxSetup({
//	'beforeSend':function(xhr) {xhr.setRequestHeader('Accept','text/javascript')}
//})

jQuery(document).ready(function($) {

	$(".list_action_hidden").show();

	$(".row_mark_header").click(function () {
		var check = $(this).is(':checked');
		$(".row_mark_elem").each(function (i) {
			$(this).attr('checked',check);
		});
	});

	$(".dropdownmenu").change(list_action=function () { 
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
					id = $(this).attr("id").substring(9,$(this).attr("id").length);
					ids+= (id+"&");
					ids_array.push(id);
				}
			});

			var path = active_controller_url+"/list_action";

			$.post(path, {"actions": action,"ids":ids}, function(data){
				if(data == "")
				{
					$(".flash").renderFlash("notifier.action_failure", "error");	
					$(".dropdownmenu").bind('change', list_action);	
				}
				else
				{
					//jQuery.globalEval(data);
					$(".flash").renderFlash("notifier.action_success", "notice");	
					$(".dropdownmenu").bind('change', list_action);
				}
			}, "html");
			$(this).get(0).selectedIndex = 0;		
		  }
	    });
	});
