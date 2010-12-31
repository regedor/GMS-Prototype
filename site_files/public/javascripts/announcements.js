var an_ammount = 0;
var an_id = -1;
var an_old_id = 0;
var an_callback_id = 0;

function announcementsCicle(callback_id) {
	if (an_callback_id == callback_id) {
		an_id = (an_id + 1) % an_ammount;
		showAnnouncement();
		nextAnnouncement(6000);
	}
}

function changeAnnouncement(id) {
	an_id = id;
	showAnnouncement();
	nextAnnouncement(12000);
}

function nextAnnouncement(millis) {
	var callback_id = ++an_callback_id;
	setTimeout(function() { announcementsCicle(callback_id) }, millis);
}

function showAnnouncement() {
	document.getElementById("announcement" + (an_old_id + 1)).style.display = "none";
	an_old_id = an_id;
	document.getElementById("announcement" + (an_id + 1)).style.display = "block";
}

function announcementsRoutine(ammount) {
	if (ammount > 0) {
		an_ammount = ammount;
		announcementsCicle(0);
	}
}
