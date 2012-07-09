jQuery.noConflict();

jQuery(document).ready(function($) {

  var header_logo = {
    change_at: $("#who-we-are").offset().top-120,
    from: "logo",
    to: "lettering",
    current: "logo",
    
    change_to_lettering: function(){
      $("#header-logo").stop().animate({opacity: 0},1000,function(){
        $(this).css({"background-image": "url('/images/logo_lettering.png')", 
                     "background-repeat": "no-repeat", 
                     "width": "190px", 
                     "margin-top": "10px"})
               .animate({opacity: 1, height: '33px'},{queue:false,duration:1000});
      });
      $("#slogan").fadeOut(600);
      
      header_logo.from    = "lettering";
      header_logo.to      = "logo";
      header_logo.current = "lettering";
    },

    change_to_logo: function(){
      $("#header-logo").stop().animate({opacity: 0},400,function(){
        $(this).css({"background-image": "url('/logo.png')", 
                     "background-repeat": "no-repeat", 
                     "width": "130px",
                     "margin-top": "0"})
               .animate({height: '92px'},{duration:1000})
               .animate({opacity: 1},{duration:1000});
      });
      $("#slogan").fadeIn(600);

      header_logo.from    = "logo";
      header_logo.to      = "lettering";
      header_logo.current = "logo";
    },

    init : function(){
      $(window).scroll(function(){
        var current_pos = window.pageYOffset;
        if(current_pos >= header_logo.change_at && header_logo.current === "logo")
        {
           header_logo.change_to_lettering();
        }
        else if(current_pos < header_logo.change_at && header_logo.current === "lettering")
        {
           header_logo.change_to_logo();
        }
      });
    }
 };

  var first_arrow = {
    scroll_to_page: function(){
      $("body,html").animate({scrollTop:$("#who-we-are").offset().top}, 1000);
    },

    init : function(){
      $("#arrow").on('click',function(event){
        first_arrow.scroll_to_page();
        event.preventDefault();
      });
    }
  };

  var header_nav = {
    intro: $("#intro").offset().top,
    who_we_are: $("#who-we-are").offset().top,
    what_we_do: $("#what-we-do").offset().top,
    what_we_did: $("#what-we-did").offset().top,
    contact: $("#contact-us").offset().top,
    thanks: $("footer").offset().top,

    add_class_to_one: function(classable_item,class_name){
      $("a."+class_name).each(function(){
        $(this).removeClass(class_name);
      });
      $(classable_item).addClass(class_name);
    },

    current_page: function(){
      $(window).scroll(function(){
        if(window.pageYOffset >= header_nav.intro && window.pageYOffset < header_nav.who_we_are)            //Intro
          header_nav.add_class_to_one("#nav-intro","current");
        else if(window.pageYOffset >= header_nav.who_we_are && window.pageYOffset < header_nav.what_we_do)  // Who we are
          header_nav.add_class_to_one("#nav-who-we-are","current");
        else if(window.pageYOffset >= header_nav.what_we_do && window.pageYOffset < header_nav.what_we_did) // What we do
          header_nav.add_class_to_one("#nav-what-we-do","current");
        else if(window.pageYOffset >= header_nav.what_we_did && window.pageYOffset < header_nav.contact)    // What we did
          header_nav.add_class_to_one("#nav-what-we-did","current");
        else if(window.pageYOffset >= header_nav.contact && window.pageYOffset < header_nav.thanks)         // Contact
          header_nav.add_class_to_one("#nav-contact","current");
        else if(window.pageYOffset >= header_nav.thanks)                                                    // Thanks
          header_nav.add_class_to_one("#nav-thanks","current");
      });
    },

    scroll_to_page: function(){
      $("nav").on("click","a",function(event){
        console.log($(this).attr("id"));
        var new_pos = header_nav.intro;
        switch($(this).attr("id")) {
          case "nav-intro":
            new_pos = header_nav.intro;
            break;
          case "nav-who-we-are":
            new_pos = header_nav.who_we_are;
            break;
          case "nav-what-we-do":
            new_pos = header_nav.what_we_do;
            break;
          case "nav-what-we-did":
            new_pos = header_nav.what_we_did;
            break;
          case "nav-contact":
            new_pos = header_nav.contact;
            break;
          case "nav-thanks":
            new_pos = header_nav.thanks;
            break;
          default:
            new_pos = header_nav.intro;
        }
        console.log(new_pos);
        $("body,html").animate({scrollTop:new_pos}, 1000);

        event.preventDefault();
      });
    },

    init: function(){
      $("#nav-intro").addClass("current");
      header_nav.current_page();
      header_nav.scroll_to_page();
    }
  };

  var the_team = {
    current_member_showing: null,

    show_members: function(){
      $("#team-list").on("click", "a", function(event){
        var member_to_show = $(this).data("name");
        if(the_team.current_member_showing != null)
          $("#"+the_team.current_member_showing).hide('fast');

        $("header").hide();
        $("#"+member_to_show).css({'position':'absolute','top':'720px'})
            .show("blind",{ direction: "horizontal" }, 2000)
            .delay(5000)
            .hide("blind",{ direction: "horizontal" }, 2000,function(){$("header").show();});
        the_team.current_member_showing = member_to_show;

        event.preventDefault();
      });
    },

    init: function(){
      the_team.show_members();
    }
  };

  header_logo.init();
  header_nav.init();
  first_arrow.init();
  the_team.init();

});