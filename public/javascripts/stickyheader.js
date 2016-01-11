// This script makes the #stickyheader menu div 'stick' to the top of the screen when the page is scrolled down
//********
// Rewrite this so that it can be used like this to give an element the sticky behavior:
//    $('#myHeader').stickyHeader();

$(function() {
        // Check the initial Position of the Sticky Header
        var stickyHeaderTop = $('#stickyheader').offset().top;
 
        $(window).scroll(function(){
                if( $(window).scrollTop() > stickyHeaderTop ) {
                        $('#stickyheader').css({position: 'fixed', top: '0px'});
                        $('#stickyalias').css('display', 'block');
                } else {
                        $('#stickyheader').css({position: 'static', top: '0px'});
                        $('#stickyalias').css('display', 'none');
                }
        });
  });
