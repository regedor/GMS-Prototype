//jQuery.noConflict();
$=jQuery;

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

jQuery.fn.float_bar = function() {
  $=jQuery;
  var element = $(this);
  var tag_cloud_offset = $(this).offset();

  $(window).scroll(function(e) {

    var main_offset = $("div#main").offset();

    if ($(this).scrollTop() > 400) {
      element.css({'position': 'fixed', 'top': element.scrollTop() + 20, 'left': tag_cloud_offset.left });
    }
    else if ($(this).scrollTop() <= 400) {
      element.css({'position': 'absolute', 'top': '245px', 'left': (tag_cloud_offset.left - main_offset.left + 20) });
    }
  });
}

jQuery.fn.float_bar_nemum = function(top) {
  $=jQuery;
  var element = $(this);
  var navigation_offset = $(this).offset();

  $(window).scroll(function() {

    if ($(this).scrollTop() > 240 && element.css('position') != 'fixed') {
      element.css({'position': 'fixed', 'top': top});
    }
    else if ($(this).scrollTop() <= 240){
      element.css({'position': 'relative', 'top': '0px'});
    }
  });
}

jQuery.fn.renderFlash = function(path,status,pairs){
	var renderedObject = this;
	asyncTranslate(path,function(data){renderedObject.html("<div class=\"message "+status+"\"><p>"+data+"</p></div>");},pairs);
}

jQuery.fn.renderFlashFrontend = function(status,text){
    $(this).prepend("<div id=\"flash\"><div class=\"message "+status+"\"><p>"+text+"</p> </div></div>");
    
    $("#flash").hide().toggle("fade", {}, 2500).delay(4000).toggle("slide", { direction: "down" }, 1500);
}
