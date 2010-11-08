jQuery.noConflict();

//jQuery.ajaxSetup({
//	'beforeSend':function(xhr) {xhr.setRequestHeader('Accept','text/javascript')}
//})


jQuery(document).ready(function($){
	$(".dropdownmenu").change(function () {
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
		    
		    $(this).get(0).selectedIndex = 0;
			
			var path = active_controller_url.substring(1,active_controller_url.length)+"/do_action";
		    $.post(path,{"actions": action,"ids":ids},
				function(data)
				{
					if(data.response == "OK")
					{
						$.each(ids_array,function(index,value){
							$("#as_admin__"+active_controller+"-list-"+value+"-row").remove();
						})
						alert(data.message);
						$(".flash").render(data.message);
					}
					
				}
				,"json");
				
		  }
        });
 });
