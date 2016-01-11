// Create the tooltips only when document ready
$(document).ready(function()
{
    // We'll target all AREA elements with alt tags - Don't target the map element!!!
    $('area[alt]').each(function() {
        $(this).qtip(
        {
            content: {
                text: $(this).next('.tooltiptext')
            },
            style: {
                classes: 'qtip-tipsy ui-tooltip-shadow',
                tip: true
            },
            position: {
                my: 'center left',
                at: 'center right'
            },
            show: {
                solo: true
            },
            hide: {
                fixed: true,
                delay: 300
            },
            events: {
                render: function(event, api) {
                    var tooltip = $(this);

                    // Hide when escape is pressed (taken from the modal plugin source)
                    $(window).bind('keydown', function(event) {
                        if (event.keyCode === 27 && tooltip.hasClass('ui-tooltip-focus')) {
                            api.hide(event);
                        }
                    });
                },
                show: function(event, api) {
                    api.elements.target.one('click', function() {
                        api.set('hide.event', 'unfocus');
                    });
                },
                hide: function(event, api) {
                    api.set('hide.event', 'mouseleave');
                }
            }
        });
    });

});



//preload the images to minimize flickering when the images are swapping (for the Regional Image Map)
/*
var theImages = new Array();
theImages[0]= new Image();
theImages[0].src="/images/region_map/r1.jpg";
theImages[1]= new Image();
theImages[1].src="/images/region_map/r2.jpg";
theImages[2]=new Image();
theImages[2].src='/images/region_map/r3.jpg';
theImages[3]=new Image();
theImages[3].src='/images/region_map/r4.jpg';
theImages[4]=new Image();
theImages[4].src='/images/region_map/r5.jpg';
theImages[5]=new Image();
theImages[5].src='/images/region_map/r6.jpg';
theImages[6]=new Image();
theImages[6].src='/images/region_map/r8.jpg';
theImages[7]=new Image();
theImages[7].src='/images/region_map/r9.jpg';
theImages[8]=new Image();
theImages[8].src='/images/region_map/r10.jpg';
 
function swapImage(imgPath){
	document.getElementById("region_image_map").src = imgPath;
	//document.region_image_map.src = imgPath;
}

*/