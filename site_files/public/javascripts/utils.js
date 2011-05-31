jQuery.noConflict();

function t(path,pairs){
	return translate(path,pairs);
}

function translate(path,pairs){
	var translation = "";
	if (pairs == null) {
		jQuery.ajax({
			url: "/api/i18n",
			async: false,
			data: {"path":path},
			success: function(data) { translation = data; }
		});
	} else {
		jQuery.ajax({
			url: "/api/i18n",
			async: false,
			data: {"path":path,"pairs":pairs},
			success: function(data) { translation = data; }
		});
	}
	return translation;
}

function asyncTranslate(path,cb,pairs){
	if (pairs == null)
		return jQuery.get("/api/i18n",{"path":path},cb,"text");
	else
		return jQuery.get("/api/i18n",{"path":path,"pairs":pairs},cb,"text");
}

jQuery.fn.renderFlash = function(path,status,pairs){
	var renderedObject = this;
	asyncTranslate(path,function(data){renderedObject.html("<div class=\"message "+status+"\"><p>"+data+"</p></div>");},pairs)
}

function float_bar(element,top) {
  $=jQuery;

  var tag_cloud_offset = $("div#tag-cloud").offset();

  $(window).scroll(function(e){ 

    var main_offset = $("div#main").offset();

    if ($(this).scrollTop() > 450){ 
      $(element).css({'position': 'fixed', 'top': $(element).scrollTop() + 30, 'left': tag_cloud_offset.left});
    }
    if ($(this).scrollTop() < 450){ 
      $(element).css({'position': 'absolute', 'top': '320px', 'left': (tag_cloud_offset.left - main_offset.left)});
    }
    
  });
}
