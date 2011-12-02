jQuery.noConflict();

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
  setDatepickerWithTime(true);
}

function setDatepickerWithTime(time){
  var counter = 0;
  var locale = "";
  for (i in $.datepicker.regional) {
    if (counter == 1) {
      locale = i;
      break;
    }
    counter++;
  }
  $.datepicker.setDefaults( $.datepicker.regional[ '' ] );
  if(time)
    $(".datepicker" ).datetimepicker($.datepicker.regional[locale]);
  else
    $(".datepicker" ).datepicker($.datepicker.regional[locale]);
}

function setDatepickerAndTime(){
  var counter = 0;
  var locale = "";
  for (i in $.datepicker.regional) {
    if (counter == 1) {
      locale = i;
      break;
    }
    counter++;
  }
  $.datepicker.setDefaults( $.datepicker.regional[ '' ] );
  $(".datetimepicker" ).datetimepicker($.datepicker.regional[locale]);
  $(".datepicker" ).datepicker($.datepicker.regional[locale]);
}

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

jQuery.fn.float_bar = function(top){
  $=jQuery;

  var element = $(this);
  var tag_cloud_offset = $(this).offset();

  $(window).scroll(function(e){ 

    var main_offset = $("div#main").offset();

    if ($(this).scrollTop() > 455){
      element.css({'position': 'fixed', 'top': element.scrollTop() + 30, 'left': (tag_cloud_offset.left - 20), 'width': '17.3%'});
    }
    else if ($(this).scrollTop() <= 455){
      element.css({'position': 'absolute', 'top': '295px', 'left': (tag_cloud_offset.left - main_offset.left - 23), 'width': '22%'});
    }
    
  });
}

jQuery.fn.float_bar_nemum = function(top){
  $=jQuery;

  var element = $(this);
  var navigation_offset = $(this).offset();

  $(window).scroll(function(){ 

    if ($(this).scrollTop() > 240 && element.css('position') != 'fixed'){ 
      element.css({'position': 'fixed', 'top': top}); 
    }
    else if ($(this).scrollTop() <= 240){ 
      element.css({'position': 'relative', 'top': '0px'});
    }

  });  
};

jQuery.fn.renderFlash = function(path,status,pairs){
	var renderedObject = this;
	asyncTranslate(path,function(data){renderedObject.html("<div class=\"message "+status+"\"><p>"+data+"</p></div>");},pairs);
}; 


// Open external links in a new tab
jQuery(document).ready(function($) {
  $("a").click(function() {
    link_host = this.href.split("/")[2];
    document_host = document.location.href.split("/")[2];

    if(this.href === "javascript:;")
      return false;

    if (link_host != document_host || this.href.split("/")[3] == "textile_help.html") {
      window.open(this.href);
      return false;
    }
  });
});
