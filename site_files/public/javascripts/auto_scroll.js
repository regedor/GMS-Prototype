jQuery(document).ready(function($) {      
    jQuery.fn.autoscroll = function(){     
      var new_postion = $(this).offset();
      $('html, body').animate({scrollTop:new_postion.top-20}, 1000);
    };
});