(function() {
  document.on("dom:loaded", function() {
    
    var containers = $$('.map_canvas');
    for(var n=0; n<containers.length; n++) {
      loadGoogleMap(containers[n]);
    }
    return false;
  });
})();

function loadGoogleMap(container) {
  //get all of container's attributes that begin with 'data-'
  var options = getDataAttributes(container, {removePrefixes: true});
  //convert attribute names from under_scored to camelCase
  options = camelCaseKeys(options);
  if(!options.center) options.center = "United States";
  if(!options.zoom) options.zoom = 13;
  if(!options.mapTypeId) options.mapTypeId = google.maps.MapTypeId.ROADMAP;
  var address = options.center;
  //we must convert strings to their intended data types, i.e.
  //"123" becomes the number 123, "true" becomes the boolean true.
  options = typifyStringValues(options);
  var g = new google.maps.Geocoder();
  g.geocode({"address": options.center}, function(result, status) {
    options.center = result[0].geometry.location; // options.center is now a lat/lon
    //alert(result[0].geometry.location_type);
    var map = new google.maps.Map(container, options);
    var marker = new google.maps.Marker({map: map, position: options.center});
    var infowindow = new google.maps.InfoWindow({content: options.infoWindowContent});

    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });

  });
}
