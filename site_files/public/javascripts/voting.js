jQuery(document).ready(function($){
  $("div.votes a").live("click", function(event){
    $.ajax({
      type: 'GET',
      url: $(this).attr("href"),
      error: function() {
        $(".flash").renderFlash("notifier.actions.failure", "error", {"action":"vote"});
        return false;
      },
      success: function(html) {
        $(".votes").replaceWith(html);
      }
    });
    
    event.preventDefault();
  });
});