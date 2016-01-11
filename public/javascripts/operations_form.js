/*
Because the Operations form requires a lot of special javascript, this file is dedicated to it.
*/

(function() {
  document.on("change", "select[id='aircraft_type_shortname']", aircraftShortnameChanged);
  document.on("change", "select[id='aircraft_type_configuration']", aircraftConfigurationChanged);
  document.on("dom:loaded", function() {
    addRappellerAutocompleters($('rappeller_configuration'));
    $("rappeller_configuration").select(".rappel_container").each(function(el) {
      var person_fullname;
      if(person_fullname = el.down('input[name=person_fullname]')) {
        if(person_fullname.value == "") { clearRappelForm(el); }
      }
    });
  });
})();

var RappelInPlaceForm = Class.create(AjaxInPlaceFormListener, {
  //initialize: function($super
});

function aircraftShortnameChanged(event, element) {
  var option = element.down("option[selected]");
  //create the configuration select box if necessary
  if(option.readAttribute("data-configurations")) {
    var configSelect = createConfigSelectionBox(option.readAttribute("data-configurations").split(","),
                                                {"class": "add_content",
                                                 "data-insertion": "update",
                                                 "data-container": "rappeller_configuration",
                                                 "data-partial": option.readAttribute("value").toLowerCase().gsub(" ", "_")});
  }
  else {
    var configSelect = "";
  }
  $("aircraft_config_select").update(configSelect);
  //save the information in the rappel containers
  var rappels = cloneRappels();
  //render the appropriate aircraft schematic
  option.fire("emulate:clicked");
  updateNameAndConfigField();
  //restore the rappel containers
  restoreRappels(rappels);
  addRappellerAutocompleters($('rappeller_configuration'));
  event.stop();
}

function cloneRappels() {
  var rappels = [];
  $('rappeller_configuration').select('.rappel_container').each(function(r) { rappels.push(r.clone(true)); });
  return rappels;
}

function restoreRappels(rappels) {
  for(var n=0; n<rappels.length; n++) {
    var container;
    if(container = $(rappels[n].id)) {
      container.replace(rappels[n]);
    }
  }
  addListeners($('rappeller_configuration'));
}

function aircraftConfigurationChanged(event, element) {
  var option = element.down("option[selected]");
  option.fire("emulate:clicked");
  updateNameAndConfigField();
  event.stop();
}

function createConfigSelectionBox(values, options) {
  var e = new Element("select", {"id": "aircraft_type_configuration", "name": "aircraft_type_configuration"});
  for(var n=0; n<values.length; n++) {
    var attributes = Object.clone(options);
    attributes.value = values[n];
    attributes["data-partial"] += "_" + values[n].toLowerCase();
    var option = new Element("option", attributes).update(values[n]);
    new RenderPartialListener(option);
    e.insert(option);
  }
  return e;
}

function updateNameAndConfigField() {
  /*
  updates the form's 'aircraft_name_and_config' field
  whenever the aircraft name or configuration selection is changed.
  */
  var e = $('operation_aircraft_name_and_config');
  var aircraft_name = $('aircraft_type_shortname').value;
  var aircraft_config = "";
  if($('aircraft_type_configuration')) {
    aircraft_config = " " + $('aircraft_type_configuration').value;
  }
  e.writeAttribute("value", aircraft_name + aircraft_config);
}

function addRappellerAutocompleters(element) {
  var selector = '[data-rappeller_autocomplete]';
  addAutocompleteListeners(element, {
    selector: selector,
    onSelect: function(item, value) {
      setRappelPerson(this.el.up('.rappel_container'), value);
    },
    onBlur: function() {
      //if the text field is not an ajax in-place style
      if (this.el.up().nodeName != "FORM") {
        if (this.el.value == "") { clearRappelForm(this.el.up('.rappel_container')); }
      }
      else {
        if (this.el.value == "") { clearRappelPerson(this.el.up('.rappel_container')); }
      }
    }
  });
}

function setRappelPerson(rappelContainer, person_id) {
  rappelContainer.down('[data-id_field]').writeAttribute('value', person_id);
  rappelContainer.down('img').writeAttribute('src', '/images/headshots/' + person_id + '-original.jpg');
  rappelContainer.select('input', 'select').each(function(child) { child.enable(); });
}

function clearRappelForm(rappelContainer) {
  rappelContainer.down('[data-id_field]').writeAttribute('value', null);
  rappelContainer.down('img').src = '/images/headshots/missing.jpg';
  rappelContainer.select('input', 'select').each(function(child) { child.disable(); });
  rappelContainer.down('input[name=person_fullname]').enable();
}

function clearRappelPerson(rappelContainer) {
  rappelContainer.down('[data-id_field]').writeAttribute('value', null);
  rappelContainer.down('img').onerror();
}
