( function($) {


$(document).ready(function() {
  var form = $('form.formtastic');
  $(".edit").parent().hide();

  if (form.length > 0 && form.attr('id').match(/^(new_post|edit_post|new_page|edit_page|new_to_do_comment)/)) {
    var dest = window.location.href.replace(/\#.*/,"").replace(/\?.*/,"");
	if (!dest.match(/\/new$/)) {
      dest = dest.replace(/\/\d+\/edit$/, '');
      //dest = dest + '/new';
    }
	else
	{
		dest = dest.replace(/\/new$/, '');
	}
    dest = dest + '/preview'

    var toggle_preview = function() {
      if ($('#preview').length == 0) {
        $(".inputs").hide();
        $(".edit").parent().show();
        $(".preview").parent().hide();
		if(form.attr('id') == "new_to_do_comment")
		{	
		  $("#to_do_comment_body_input").after('<div id="preview"></div>');
		  $(".inputs").show();	
		  $("#to_do_comment_body_input").hide();
		}
		else
          form.before('<div id="preview"></div>');

        jQuery.ajax({
          type: 'POST',
          data: form.serialize().replace(/&*_method=\w+&*/, '')+'&id='+window.location.pathname.split('/')[3],
          url: dest,
          dataType: 'html',
          error: function(response,text,error) {
            title = t('admin.posts.preview.title');
            ret = t('admin.posts.preview.return');
            error = t('admin.posts.preview.error');
            $('#preview').html('<h3>' + title + '</h3><p>' + ret + '</p><p>' + error + '</p>');
          },
          success: function(r) {
            $('#preview').html(r);
          }
        });
      }
      else {
        $('#preview').remove();
        $(".inputs").show();
        $(".edit").parent().hide();
        $(".preview").parent().show();
        if(form.attr('id') == "new_to_do_comment")
		  $("#to_do_comment_body_input").show();
      }
    }

	$('.preview').click(function(){
		toggle_preview();
	});
	
	$('.edit').click(function(){
		toggle_preview();
	});

    $(document).keyup(function(e) {
      if (e.metaKey && (e.which == 69)) {
        toggle_preview();
        e.preventDefault();
      }
    });
  }
});

} ) ( jQuery );
