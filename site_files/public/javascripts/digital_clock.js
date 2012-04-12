jQuery(document).ready(function($){
  setInterval( function() {
    // Create a newDate() object and extract the seconds of the current time on the visitor's
    var seconds = new Date().getUTCSeconds();
    // Add a leading zero to seconds value
    $("li.sec").html(( seconds < 10 ? "0" : "" ) + seconds);
    },1000);
  
  setInterval( function() {
    // Create a newDate() object and extract the minutes of the current time on the visitor's
    var minutes = new Date().getUTCMinutes();
    // Add a leading zero to the minutes value
    $("li.min").html(( minutes < 10 ? "0" : "" ) + minutes);
    },1000);
  
  setInterval( function() {
    // Create a newDate() object and extract the hours of the current time on the visitor's
    var hours = new Date().getUTCHours();
    // Add a leading zero to the hours value
    $("li.portugal-hours").html(( hours < 10 ? "0" : "" ) + (hours+1));
    $("li.france-hours").html(( hours < 10 ? "0" : "" ) + (hours+2));
    }, 1000);
});