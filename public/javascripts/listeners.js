/*
This file contains all javascript event listeners and their associated callbacks.

A brief summary of Unobtrusive Javascript (UJS):
The intent is to keep javascript code out of the html source.  The method is
that any time event-based javascript is required, instead of
placing js in the onclick, onload, etc. attribute of an html element, that
element is instead given an arbitrary attribute prefixed with "data-" and set to true.
The code in this file attaches the desired javascript code to an event callback on whatever
page elements contain that attribute.
*/


var AjaxElementListener = Class.create({
  initialize: function(element) {
    if(!AjaxElementListener.instances.include(element)) {
      this.el = element;
      var error_container_id = this.el.readAttribute('data-error_container');
      if(error_container_id) {
        this.error_container = $(error_container_id);
      }
      else {
        this.error_container = new Element('div', {'class': 'ajax_error_msg'});
        this.el.insert({after: this.error_container});
        this.el.writeAttribute('data-error_container', this.error_container.identify());
      }
      AjaxElementListener.instances.push(this.el);
      return true;
    }
    return false;
  },
  failure: function(event) {
    this.response = event.memo.responseJSON;
    alert("error");
  }
});
AjaxElementListener.instances = [];

var AjaxCheckboxListener = Class.create(AjaxElementListener, {
  initialize: function($super, element) {
    if($super(element)) {
      this.loadingIcon = this.el.down("img[data-icon='loading']");
      Event.observe(this.el, "ajax:before", this.beforeSubmit.bind(this));
      Event.observe(this.el, "ajax:failure", this.failure.bind(this));
    }
  },
  beforeSubmit: function(event) {
    this.loadingIcon.show();
    this.el.down("input[data-icon='1']").hide();
    this.el.down("input[data-icon='1']").writeAttribute("disabled");
  }
});
AjaxCheckboxListener.createAll = function(scopeElement) {
  var elements = scopeElement.select('[data-ajax_checkbox]');
  for(var n=0; n<elements.length; n++) { new AjaxCheckboxListener(elements[n]); }
}

var AjaxInPlaceFormListener = Class.create(AjaxElementListener, {
  initialize: function($super, element) {
    if($super(element)) {
      this.editText = this.el.down('.edit_text');
      this.text = this.editText.up('span');
      this.form = this.el.down('form');
      Event.observe(this.el, "mouseover", this.mouseover.bind(this));
      Event.observe(this.el, "mouseout", this.mouseout.bind(this));
      Event.observe(this.el, "click", this.clicked.bind(this));
      Event.observe(this.el, "ajax:failure", this.failure.bind(this));
    }
  },
  mouseover: function(event) {
    this.el.writeAttribute("class", "in_place_form_mouseover");
    this.editText.show();
  },
  mouseout: function(event) {
    this.el.writeAttribute("class", "in_place_form_mouseout");
    this.editText.hide();
  },
  clicked: function(event) {
    this.form.show();
    this.text.hide();
    this.editText.hide();
  }
});
AjaxInPlaceFormListener.createAll = function(scopeElement) {
  var elements = scopeElement.select('[data-ajax_in_place_form]');
  for(var n=0; n<elements.length; n++) {
    new AjaxInPlaceFormListener(elements[n]);
  }
}

var RenderPartialListener = Class.create({
  initialize: function(element) {
    if(!RenderPartialListener.instances.include(element)) {
      this.el = element;
      this.partial_id = this.el.readAttribute("data-partial");
      this.method = this.el.readAttribute("data-insertion");
      this.position = this.el.readAttribute("data-position");
      this.container_id = this.el.readAttribute("data-container");
      this.container = (this.container_id ? $(this.container_id) : this.el.up());

      Event.observe(this.el, "click", this.clicked.bind(this));
      Event.observe(this.el, "emulate:clicked", this.clicked.bind(this));
      RenderPartialListener.instances.push(this.el);
    }
  },
  clicked: function(event) {
    var content = unmakeUniqueTemplateIds($(this.partial_id + "_template").clone(true));
    content = content.innerHTML;
    switch(this.method) {
    case "insert":
      var obj = new Object;
      obj[this.position] = content;
      this.container.insert(obj);
      break;
    case "update":
      this.container.update(content);
      break;
    case "replace":
      this.container.replace(content);
      break;
    }
    addListeners(this.container);
    event.stop();
  }
});
RenderPartialListener.instances = [];
RenderPartialListener.createAll = function(scopeElement) {
  var elements = scopeElement.select('.add_content');
  for(var n=0; n<elements.length; n++) { new RenderPartialListener(elements[n]); }
}

function makeUniqueTemplateIds(element) {
  /*
  Appends a serial number to the id of each descendant of element that has an id.
  This function is used to maintain id uniqueness when hidden elements get
  inserted at the bottom of the page for dynamic rendering later on.  When
  they get copied into the page and shown, the serial numbers are removed by unmakeUniqueTemplateIds.
  */
  var children = element.select('[id]');
  for(var n=0; n<children.length; n++) {
    if(!children[n].id.match(/.*_template$/)) {
      children[n].writeAttribute('id', children[n].id + "_" + n);
    }
  }
  return element;
}

function unmakeUniqueTemplateIds(element) {
  var children = element.select('[id]');
  for(var n=0; n<children.length; n++) {
    if(children[n].id.match(/.*_\d+$/)) {
      children[n].writeAttribute('id', children[n].id.gsub(/_\d+$/, ""));
    }
  }
  return element;
}

function promptedInputFocused(event) {
  if(this.readAttribute("data-empty") == "true") {
    var style;
    if(style = this.readAttribute("style")) {
      var color = style.match(/color:[^;\"\']+/);
      if(color) {
        style = style.sub(color[0], "color:#000000");
      }
      else {
        style = "color:#000000;" + style;
      }
    }
    else {
      style = "color:#000000";
    }
    this.writeAttribute("style", style);
    this.clear();
  }
}

function promptedInputBlurred(event) {
  if(!this.getValue() || this.getValue() == "") {
    var style;
    if(style = this.readAttribute("style")) {
      var color = style.match(/color:[^;\"\']+/);
      if(color) {
        style = style.sub(color[0], "color:#aaa");
      }
      else {
        style = "color:#aaa;" + style;
      }
    }
    else {
      style = "color:#aaa";
    }
    this.writeAttribute("style", style);
    this.writeAttribute("data-empty", "true");
    this.setValue(this.readAttribute("data-prompt"));
  }
  else {
    this.writeAttribute("data-empty", "false");
  }
}

function addAutocompleteListeners(element, options) {
  if(!options.selector) { options.selector = '[data-autocomplete]' }
  clearAutocompleteListeners(element, options.selector);
  var autocomplete_fields = element.select(options.selector);
  delete options.selector
  for(var n=0; n<autocomplete_fields.length; n++) {
    var field = autocomplete_fields[n];
    var fieldOptions = Object.clone(options, true);
    Object.extend(fieldOptions, get_autocomplete_options(field));
    if(!fieldOptions.serviceUrl) {
      Object.extend(fieldOptions, { serviceUrl: field.readAttribute('data-autocomplete') });
    }
    if(fieldOptions.idSelector) {
      Object.extend(fieldOptions, { onSelect: onIdSelectorSelect, onBlur: onIdSelectorBlur });
    }
    new Autocomplete(field.identify(), fieldOptions);
  }
}

function clearAutocompleteListeners(element, selector) {
  var fields = element.select(selector);
  for(var i=0; i<fields.length; i++) {
    for(var n=0; n<Autocomplete.instances.length; n++) {
      if(Autocomplete.instances[n].el.identify() == fields[i].identify()) {
        Autocomplete.instances.splice(n, 1);
        for(var j=n; j<Autocomplete.instances.length; j++) {
          Autocomplete.instances[j].instanceId--;
        }
        break;
      }
    }
  }
}

function onIdSelectorSelect(item, value) {
  $(this.options.idSelector).value = value;
}

function onIdSelectorBlur() {
  if(this.el.value == "") { $(this.options.idSelector).value = null; }
}

function get_autocomplete_options(element) {
  //all html attributes prefixed with 'data-autocomplete_' are considered autocomplete options,
  //where the suffix of the attribute is the name of an option accepted by Autocomplete.js.
  var attributes = element.attributes;
  var options = {};
  var attr_names = [];
  //collect attribute names
  for(var n=0; n<attributes.length; n++) {
    attr_names.push(attributes[n].name);
  }
  //keep only attributes with the 'data-autocomplete_' prefix
  attr_names = attr_names.grep(/^(data-autocomplete_)/);
  for(var n=0; n<attr_names.length; n++) {
    var name = attr_names[n].gsub(/^(data\-autocomplete_)/, "").camelCase();
    options[name] = attributes[attr_names[n]].value;
  }
  return options;
}

function addListeners(element) {
  AjaxCheckboxListener.createAll(element);
  AjaxInPlaceFormListener.createAll(element);
  RenderPartialListener.createAll(element);
  addAutocompleteListeners(element, {});
}

function submitClicked(event, element) {
  //text fields with a prompt shouldn't submit the prompt
  element.up("form").select("[data-prompt]").each(function(el) {
    if(el.readAttribute("data-empty") == "true") { el.value = ""; }
  });
}

(function() {
  Element.addMethods({
    fancyInsert: function(element, content) {
      if(!(element = $(element))) return;
      element.insert({
        top: '<div style="display:none"><div>' + content + '</div></div>'
      });
      new Effect.SlideDown(element.down("div"));
      return element;
    }
  });
  
  document.on("dom:loaded", function() {
    if($('dynamic_elements')) { makeUniqueTemplateIds($('dynamic_elements')); }
    $$("input[data-prompt]").each(function(element) {
      Event.observe(element, "focus", promptedInputFocused.bind(element));
      Event.observe(element, "blur", promptedInputBlurred.bind(element));
      Event.observe(element, "emulate:blur", promptedInputBlurred.bind(element));
      Event.fire(element, "emulate:blur");
    });
    document.on("click", "input[type=submit]", submitClicked);
    addListeners($('content'));
  });
})();