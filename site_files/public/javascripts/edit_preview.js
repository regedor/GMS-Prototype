( function($) {


$(document).ready(function() {
  var form = $('form.formtastic');

  if (form.length > 0 && form.attr('id').match(/^(new_post|edit_post|new_page|edit_page)/)) {
    var dest = window.location.href.replace(/\/$/, '');
    if (!dest.match(/\/new$/)) {
      dest = dest.replace(/\/\d+\/edit$/, '');
      dest = dest + '/new';
    }
    dest = dest + '/preview'

    var toggle_preview = function() {
      if ($('#preview').length == 0) {
        $(".inputs").hide();
        $(".edit_button").show();
        $(".preview_button").hide();
        form.before('<div id="preview"></div>');

        jQuery.ajax({
          type: 'POST',
          data: form.serialize().replace(/&*_method=\w+&*/, ''),
          url: dest,
          error: function() {
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
        $(".edit_button").hide();
        $(".preview_button").show();
      }
    }

	$('.preview_button').click(function(){
		toggle_preview();
	});
	
	$('.edit_button').click(function(){
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
