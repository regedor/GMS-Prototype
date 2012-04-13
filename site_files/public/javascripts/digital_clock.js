jQuery(document).ready(function($){

  var hours_pt   = $("#portugal-clock"), 
      hours_fr   = $("#france-clock");

  $.ajax({
     url: "http://json-time.appspot.com/time.json?callback=?", 
     dataType: "json",
     success: function(response){
       date =  new Date(response.datetime);
       renderClock();
       window.setInterval(function(){renderClock();},1000);
     }, 
     error: function(){
       date = new Date();
       renderClock();
       window.setInterval(function(){renderClock();},1000);
     }
  });

  function renderClock() {
    date = new Date(date.getTime()+1000);
    var seconds = ( date.getUTCSeconds() < 10 ? "0" : "" ) + date.getUTCSeconds();
    var minutes = ( date.getUTCMinutes() < 10 ? "0" : "" ) + date.getUTCMinutes();
    var hours = ( date.getUTCHours() < 10 ? "0" : "" ) + (date.getUTCHours()+1);
    var pt_clock = hours+":"+minutes+":"+seconds
    
    hours = ( date.getUTCHours() < 10 ? "0" : "" ) + (date.getUTCHours()+2);
    var fr_clock = hours+":"+minutes+":"+seconds

    hours_pt.text(pt_clock);
    hours_fr.text(fr_clock);
  }
});