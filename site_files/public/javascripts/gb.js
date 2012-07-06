jQuery.noConflict();

jQuery(document).ready(function($) {

  var header_logo = {
   change_at: $("#who-we-are").offset().top-120,
   from: "logo",
   to: "lettering",
   current: "logo",
   
   init : function(){
     $(window).scroll(function(){
       var current_pos = $(window).scrollTop();
       console.log(header_logo.change_at);
       console.log(current_pos)
       if(current_pos >= header_logo.change_at && header_logo.current === "logo")
       {
          $(".logo").stop().animate({opacity: 0},1000,function(){
            $(this).css({'background-image': "url('/images/logo_lettering.png')", "background-repeat": "no-repeat", "width": "190px"})
                   .animate({opacity: 1, height: '33px'},{queue:false,duration:1000});
          });
          $("#slogan").fadeOut(600);

          header_logo.from = "lettering";
          header_logo.to   = "logo";
          header_logo.current = "lettering";
        }
        else if(current_pos < header_logo.change_at && header_logo.current === "lettering")
        {
          $(".logo").stop().animate({opacity: 0},400,function(){
            $(this).css({'background-image': "url('/logo.png')", "background-repeat": "no-repeat", "width": "130px"})
                   .animate({height: '92px'},{duration:1000})
                   .animate({opacity: 1},{duration:1000});
          });
          $("#slogan").fadeIn(600);

          header_logo.from = "logo";
          header_logo.to   = "lettering";
          header_logo.current = "logo";
        }
      });
    }
  }
  
  header_logo.init();
  
});