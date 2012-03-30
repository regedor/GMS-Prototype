$(document).ready(function($){
  $("th.ec-month-nav").live('click',function(event){
    var query_params = $(this).find("a").attr("href").split("?")[1];

    $('div#event-calendar').load("/calendar?"+query_params,function(){
      $('div.events').parent().addClass("has-events");
    });

    event.preventDefault();
  });
});