jQuery.noConflict();

jQuery(document).ready(function($) {

  var header_logo = {
    change_at: $("#who-we-are").offset().top-700,
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
          $(".logo").stop().animate({"opacity": "0"}, 300, function() {
            $(this).css({"background-image": "url('/images/logo_lettering.png')", "width": "190px"})
              .animate({"opacity": "1"}, {queue: false, duration: 500})
              .animate({"padding-bottom": "13px", "height": "33px"}, {duration: 500});
            $(this).css({"background-position-y": "12px"});
          });
          $("#slogan").fadeOut(300);

          header_logo.from = "lettering";
          header_logo.to   = "logo";
          header_logo.current = "lettering";
        }
        else if(current_pos < header_logo.change_at && header_logo.current === "lettering")
        {
          $(".logo").stop().animate({"opacity": "0"}, 300, function() {
            $(this).css({"background-image": "url('/logo.png')", "background-position-y": "0", "padding-bottom": "0", "width": "130px"})
              .animate({"height": "92px"}, {duration: 300})
              .animate({"opacity": "1"}, {duration: 300});
          });
          $("#slogan").delay(500).fadeIn(300);

          header_logo.from = "logo";
          header_logo.to   = "lettering";
          header_logo.current = "logo";
        }
      });
    }
  }

  header_logo.init();
});
