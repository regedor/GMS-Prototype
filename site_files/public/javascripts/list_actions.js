jQuery.noConflict();

jQuery.ajaxSetup({
	'beforeSend':function(xhr) {xhr.setRequestHeader('Accept','text/javascript')}
})

jQuery(document).ready(function($) {

	var sheet = document.createElement('style');
	sheet.type = 'text/css';
	sheet.innerHTML = ".list_actions { display: table-cell; }\n.list_actions { *display: inline; *float: left; }";
	$('body').append(sheet);

	$(".row_mark_header").live('click', function () {
		var check = $(this).is(':checked');
		$(".row_mark_elem").each(function (i) {
			$(this).attr('checked',check);
		});
	});

	$(".dropdownmenu").change(list_action=function () {
		var selectedOption = $(".dropdownmenu option:selected");
		var action = selectedOption.attr("value");
		var verboseAction = selectedOption.html().toLowerCase();
		if(action != "")
		{
			var active_controller_url = window.location.pathname;

			var id;
			var ids = "";
			$(".row_mark_elem").each(function() {
				if($(this).is(':checked'))
				{
					id = $(this).attr("id").substring(9,$(this).attr("id").length);
					ids+= (id+"&");
				}
			});

			if (ids != "")
			{
				if (confirm(translate("notifier.actions.confirm", { "action":verboseAction })))
				{
					new Ajax.Request(active_controller_url+"/list_action", {
							asynchronous: true,
							evalScripts: true,
							method: 'post',
							parameters: {"actions": action, "ids": ids},
							onSuccess: function(data, textStatus) {
								$(".flash").renderFlash("notifier.actions.success", "notice", {"action":verboseAction});
							},
							onFailure: function(data, textStatus) {
								$(".flash").renderFlash("notifier.actions.failure", "error", {"action":verboseAction});
							}
					});
				}
			}
			else
			{
				$(".flash").renderFlash("notifier.actions.no_selection", "error");
			}

			$(".dropdownmenu").bind('change', list_action);
			$(this).get(0).selectedIndex = 0;
		  }
	    });
	});
