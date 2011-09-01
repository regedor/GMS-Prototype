jQuery.noConflict();

jQuery(document).ready(function($) {
	$(".current").removeClass("current");
	$('a[href='+unescapeFromUrl(window.location.pathname,"UTF-8")+']').addClass("current");
});