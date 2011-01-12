jQuery.noConflict();

function t(path,pairs){
	translate(path,pairs);
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
  $(window).scroll(function(e){ 
    $el = $(element); 

    if ($(this).scrollTop() > 250 && $el.css('position') != 'fixed'){ 
      $(element).css({'position': 'fixed', 'top': top}); 
    }
    if ($(this).scrollTop() < 250){ 
      $(element).css({'position': 'relative', 'top': '0px'}); 
    }
    
  });
}
