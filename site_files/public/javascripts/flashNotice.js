jQuery.noConflict();

jQuery.fn.render = function(message){
	this.html("<div class=\"message notice\"><p>"+message+"</p></div>");
}