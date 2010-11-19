jQuery.noConflict();

function t(path,cb){
	ret_val = jQuery.get("/api/i18n",{"path":path},cb,"text");
}

jQuery.fn.renderFlash = function(path,status){
	var renderedObject = this;
	t(path,function(data){renderedObject.html("<div class=\"message "+status+"\"><p>"+data.replace(/"/g,'')+"</p></div>");})
}