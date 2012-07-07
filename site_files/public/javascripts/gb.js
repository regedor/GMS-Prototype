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
       if(current_pos >= header_logo.change_at && header_logo.current === "logo")
       {
          $("#header-logo").stop().animate({opacity: 0},1000,function(){
            $(this).css({'background-image': "url('/images/logo_lettering.png')", "background-repeat": "no-repeat", "width": "190px"})
                   .animate({opacity: 1, height: '33px'},{queue:false,duration:1000});
          });
          $("#slogan").fadeOut(600);

          header_logo.from    = "lettering";
          header_logo.to      = "logo";
          header_logo.current = "lettering";
        }
        else if(current_pos < header_logo.change_at && header_logo.current === "lettering")
        {
          $("#header-logo").stop().animate({opacity: 0},400,function(){
            $(this).css({'background-image': "url('/logo.png')", "background-repeat": "no-repeat", "width": "130px"})
                   .animate({height: '92px'},{duration:1000})
                   .animate({opacity: 1},{duration:1000});
          });
          $("#slogan").fadeIn(600);

          header_logo.from    = "logo";
          header_logo.to      = "lettering";
          header_logo.current = "logo";
        }
      });
    }
  }

  var first_arrow = {
    init : function(){
      $("#arrow").on('click',function(event){
        $("body").animate({scrollTop:$("#who-we-are").offset().top-70}, 1000)
        event.preventDefault();
      })
    }
  }
  
  header_logo.init();
  first_arrow.init();
  
});