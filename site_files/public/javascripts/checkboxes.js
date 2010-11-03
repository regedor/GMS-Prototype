$(".row_mark_header").click(function () {
     $(".row_mark_elem").each(function (i) {
       $(this).attr('checked',!$(this).is(':checked'));
     });
 });
