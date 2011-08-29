jQuery.noConflict();

jQuery(document).ready(function($) {
			
	if(window.location.pathname !== "/")
	{
		var new_postion = $('#content').offset();
		$('html, body').animate({scrollTop:new_postion.top-20}, 1000);
    }
			
	$(".current").removeClass("current");
	$('a[href='+unescapeFromUrl(window.location.pathname,"UTF-8")+']').addClass("current");
});