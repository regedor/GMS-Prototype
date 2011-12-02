jQuery(document).ready(function($) { 
  var an_ammount = 0;
  var an_id = 0;
  //var an_old_id = 0;
  var an_callback_id = 0;
  
  function announcementsCicle(callback_id) {
  	  if (an_callback_id == callback_id) {
  	  	  id = (an_id % an_ammount)+1;
          an_id+=1;
  	      showAnnouncement(id,false);
  	      nextAnnouncement(6000);
  	  }
  }
  
  function nextAnnouncement(millis) {
  	  var callback_id = ++an_callback_id;
  	  setTimeout(function() { announcementsCicle(callback_id) }, millis);
  }
  
  function showAnnouncement(id,hover) {
      $("#announcement"+an_id).hide();
      an_id=id;
      $("#announcement"+id).show();
  }
  
  function announcementsRoutine(ammount) {
  	  if (ammount > 0) {
  	  	  an_ammount = ammount;
  	  	  announcementsCicle(0);
  	  }
  }

  setTimeout(function() {announcementsRoutine($("#announcements").children().length);}, 0);

  $(".clickable").live('click',function(){
	    parent = $('#rotators') 
		thisId = $(this).attr('id').split('-')[1]; 
		visibleId = $('li.visible').attr('id').split('-')[1]; 
	
    	if($(this).attr('class').indexOf('next') == -1) // previous
		{	
			$('li.visible').removeClass('visible').addClass('next clickable');
			if(visibleId == parent.children().length)
				parent.children(":nth-child(1)").removeClass('clickable next').addClass('not-visible');
			else
			    $("#rotator-"+(visibleId*1+1)).removeClass('clickable next').addClass('not-visible');
			
			$(this).removeClass('previous clickable').addClass('visible');
			if(thisId == 1)
				parent.children(':last').removeClass('not-visible next').addClass('previous clickable');
			else
			    $('#rotator-'+(thisId-1)).removeClass('not-visible next').addClass('previous clickable');			    			
		}
		else
		{
			$('li.visible').removeClass('visible').addClass('previous clickable');
			if(visibleId == 1)
				parent.children(':last').removeClass('clickable previous').addClass('not-visible');
			else
			    $('#rotator-'+(visibleId-1)).removeClass('clickable previous').addClass('not-visible');
						
			$(this).removeClass('next clickable').addClass('visible');
			if(thisId == parent.children().length)
				parent.children(":nth-child(1)").removeClass('not-visible previous').addClass('next clickable');
			else
			    $("#rotator-"+(thisId*1+1)).removeClass('not-visible previous').addClass('next clickable');
		}
		
		$("#announcement"+visibleId).hide();
		$("#announcement"+thisId).show();
  });

});
