// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// This file is only used to start on load methods for all instances, other methods should go to utils.js and specific methods should be in separate files

jQuery.noConflict();

jQuery(document).ready(function($) {

    $.preloadCssImages();

	var isAdmin = (document.location.href.split("/")[3] === "admin") ? true : false

	if(!isAdmin)
	{
		// Add current class to the current page
		//$(".current").removeClass("current");
		//$('a[href="'+unescapeFromUrl(window.location.pathname,"UTF-8")+'"]').addClass("current");
		//if(window.location.pathname.slice(1,5) == "icci")
		//	$('a[href="/icci-revista"]').addClass("current");
	}
	else
	{
		// Set the current category variable
		$("#categories").change(function(){
			var selected_option = $("#categories option:selected").val();
			console.log(selected_option);
			console.log(window.location);
			if(selected_option == 0)
				window.location.href = "#";
			else
			{
				$.ajax({
					type: 'GET',
					url: window.location.origin + "/admin/global_categories/set_category?option_id=" + selected_option
				});
			}
		});
	}
	
	
	// Open external links in a new tab
	$("a").click(function() {
	    link_host = this.href.split("/")[2];
	    document_host = document.location.href.split("/")[2];

	    if(this.href === "javascript:;" || this.href === "")
	      return false;

	    if (link_host != document_host || this.href.split("/")[3] == "textile_help.html") {
	      window.open(this.href);
	      return false;
	    }
	});


});