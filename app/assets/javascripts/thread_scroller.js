$(document).ready(function() {
  offset = $(".thread-view-from-here").offset()
  if(!window.location.hash && offset) {
    $('html, body').animate({
        scrollTop: offset.top
    }, 2000);
  }
});
