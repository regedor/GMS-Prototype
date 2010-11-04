$(".row_mark_header").click(function () {
     $(".row_mark_elem").each(function (i) {
       if ($(".row_mark_header").attr('checked') == true) {
         $(this).attr('checked',true);
       } else {
           $(this).attr('checked',false);
         }
     });
 });
