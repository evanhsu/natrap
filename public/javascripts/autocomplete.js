/*
 *
 *  Ajax Autocomplete for Prototype, version 1.0.4
 *  (c) 2010 Tomas Kirda
 *
 *  Ajax Autocomplete for Prototype is freely distributable under the terms of an MIT-style license.
 *  For details, see the web site: http://www.devbridge.com/projects/autocomplete/
 *
 *
 *  Example Usage:
 *
 *  In your VIEW:
 *  <% content_for :includes do %>
 *      <%= javascript_include_tag "autocomplete" %>
 *  <% end %>
 *
 *  <%= text_field_tag :person_fullname, {:style => "width:9em;height:1em",
 *                    "data-autocomplete" => "/people/autocomplete.json",
 *                    "data-autocomplete_container" => "rostered_person_fullname_autocomplete_container"},
 *                    "data-autocomplete_on_select" => "(function(name,id){document.getElementById('person_id').writeAttribute('value',id)})",
 *                    "data-autocomplete_width" => "200" %>
 *  <div id='rostered_person_fullname_autocomplete_container'></div>
 *  <%= f.hidden_field :person_id %>
 *
 *  In your CONTROLLER ("/people/autocomplete.json" for this example):
 *    def autocomplete
 *       @people = Person.find(:all, :conditions => ["CONCAT(firstname, CONCAT(' ', lastname)) LIKE ?", "%#{params[:query].strip}%"])
 *       @people = @people.sort_by { |p| p.fullname }
 *       response = {
 *         :query => params[:query],
 *         :suggestions => @people.map { |p| p.fullname },
 *         :data => @people.map { |p| p.id }
 *       }
 *       respond_to do |format|
 *        format.json { render :json => response.to_json }
 *       end
 *     end
 *
 *  Notes:
 *  The "data-autocomplete_on_select" callback receives 2 values when an item in the autosuggest list is clicked (selected).
 *  These 2 values come from the controller's :suggestions and :data arrays for the record that was clicked in the autosuggest list.
 *  In the example above, the "suggestions" value was named "name" and the "data" value was named "id" by the anonymous function in the 'on_select' callback.
 *
 *  Available callback actions are: onSelect, onBlur, onSuggest
 */

var Autocomplete = function(el, options){
  if(typeof(el) == "object") {
    this.el = el;
  }
  else {
    this.el = $(el);
  }
  this.id = this.el.identify();
  this.el.setAttribute('autocomplete','off');
  this.suggestions = [];
  this.data = [];
  this.badQueries = [];
  this.selectedIndex = -1;
  this.currentValue = this.el.value;
  this.intervalId = 0;
  this.cachedResponse = [];
  this.instanceId = null;
  this.onChangeInterval = null;
  this.ignoreValueChange = false;
  this.serviceUrl = options.serviceUrl;
  this.options = {
    autoSubmit:false,
    minChars:1,
    maxHeight:300,
    deferRequestBy:0,
    width:0,
    container:null
  };
  if(options){ Object.extend(this.options, options); }
  this.initialize();
};

Autocomplete.instances = [];
Autocomplete.isDomLoaded = false;

Autocomplete.getInstance = function(id){
  var instances = Autocomplete.instances;
  var i = instances.length;
  while(i--){ if(instances[i].id === id){ return instances[i]; }}
};

Autocomplete.highlight = function(value, re){
  return value.replace(re, function(match){ return '<strong>' + match + '<\/strong>' });
};

Autocomplete.prototype = {

  killerFn: null,

  initialize: function() {
    var me = this;
    this.killerFn = function(e) {
      if (!$(Event.element(e)).up('.autocomplete')) {
        me.killSuggestions();
        me.disableKillerFn();
      }
    } .bindAsEventListener(this);

    if (!this.options.width) { this.options.width = this.el.getWidth(); }

    var div = new Element('div', { style: 'position:absolute;' });
    div.update('<div class="autocomplete-w1"><div class="autocomplete-w2"><div class="autocomplete" id="Autocomplete_' + this.id + '" style="display:none; width:' + this.options.width + 'px;"></div></div></div>');

    this.options.container = $(this.options.container);
    if (this.options.container) {
      this.options.container.update(div);
      this.fixPosition = function() { };
    } else {
      document.body.appendChild(div);
    }

    this.mainContainerId = div.identify();
    this.container = $('Autocomplete_' + this.id);
    this.fixPosition();
    
    Event.observe(this.el, window.opera ? 'keypress':'keydown', this.onKeyPress.bind(this));
    Event.observe(this.el, 'keyup', this.onKeyUpHandler.bind(this));
    Event.observe(this.el, 'blur', this.onBlurEvent.bind(this));
    Event.observe(this.el, 'focus', this.fixPosition.bind(this));
    this.container.setStyle({ maxHeight: this.options.maxHeight + 'px' });
    this.instanceId = Autocomplete.instances.push(this) - 1;
  },

  onBlurEvent: function() {
    this.enableKillerFn();
    this.onBlur();
  },

  fixPosition: function() {
    var offset = this.el.cumulativeOffset();
    $(this.mainContainerId).setStyle({ top: (offset.top + this.el.getHeight()) + 'px', left: offset.left + 'px' });
  },

  enableKillerFn: function() {
    Event.observe(document.body, 'click', this.killerFn);
  },

  disableKillerFn: function() {
    Event.stopObserving(document.body, 'click', this.killerFn);
  },

  killSuggestions: function() {
    this.stopKillSuggestions();
    this.intervalId = window.setInterval(function() { this.hide(); this.stopKillSuggestions(); } .bind(this), 300);
  },

  stopKillSuggestions: function() {
    window.clearInterval(this.intervalId);
  },

  onKeyPress: function(e) {
    if (!this.enabled) { return; }
    // return will exit the function
    // and event will not fire
    switch (e.keyCode) {
      case Event.KEY_ESC:
        this.el.value = this.currentValue;
        this.hide();
        break;
      case Event.KEY_TAB:
      case Event.KEY_RETURN:
        if (this.selectedIndex === -1) {
          this.hide();
          return;
        }
        this.select(this.selectedIndex);
        if (e.keyCode === Event.KEY_TAB) { return; }
        break;
      case Event.KEY_UP:
        this.moveUp();
        break;
      case Event.KEY_DOWN:
        this.moveDown();
        break;
      default:
        return;
    }
    Event.stop(e);
  },

  onKeyUpHandler: function(e) {
    switch (e.keyCode) {
      case Event.KEY_UP:
      case Event.KEY_DOWN:
        return;
    }
    clearInterval(this.onChangeInterval);
    if (this.currentValue !== this.el.value) {
      if (this.options.deferRequestBy > 0) {
        // Defer lookup in case when value changes very quickly:
        this.onChangeInterval = setInterval((function() {
          this.onValueChange();
        }).bind(this), this.options.deferRequestBy);
      } else {
        this.onValueChange();
      }
    }
  },

  onValueChange: function() {
    clearInterval(this.onChangeInterval);
    this.currentValue = this.el.value;
    this.selectedIndex = -1;
    if (this.ignoreValueChange) {
      this.ignoreValueChange = false;
      return;
    }
    if (this.currentValue === '' || this.currentValue.length < this.options.minChars) {
      this.hide();
    } else {
      this.getSuggestions();
    }
  },

  getSuggestions: function() {
    var cr = this.cachedResponse[this.currentValue];
    if (cr && Object.isArray(cr.suggestions)) {
      this.suggestions = cr.suggestions;
      this.data = cr.data;
      this.suggest();
    } else if (!this.isBadQuery(this.currentValue)) {
      new Ajax.Request(this.serviceUrl, {
        parameters: { query: this.currentValue },
        onComplete: this.processResponse.bind(this),
        method: 'get'
      });
    }
  },

  isBadQuery: function(q) {
    var i = this.badQueries.length;
    while (i--) {
      if (q.indexOf(this.badQueries[i]) === 0) { return true; }
    }
    return false;
  },

  hide: function() {
    this.enabled = false;
    this.selectedIndex = -1;
    this.container.hide();
  },

  suggest: function() {
    if (this.suggestions.length === 0) {
      this.hide();
      if(this.options.onEmptySuggestions) this.onEmptySuggestions();
      return;
    }
    var content = [];
    var re = new RegExp('\\b' + this.currentValue.match(/\w+/g).join('|\\b'), 'gi');
    this.suggestions.each(function(value, i) {
      content.push((this.selectedIndex === i ? '<div class="selected"' : '<div'), ' title="', value, '" onclick="Autocomplete.instances[', this.instanceId, '].select(', i, ');" onmouseover="Autocomplete.instances[', this.instanceId, '].activate(', i, ');">', Autocomplete.highlight(value, re), '</div>');
    } .bind(this));
    this.enabled = true;
    this.container.update(content.join('')).show();
    this.onSuggest();
  },

  processResponse: function(xhr) {
    var response;
    try {
      response = xhr.responseText.evalJSON();
      if (!Object.isArray(response.data)) { response.data = []; }
    } catch (err) { return; }
    this.cachedResponse[response.query] = response;
    if (response.suggestions.length === 0) { this.badQueries.push(response.query); }
    if (response.query === this.currentValue) {
      this.suggestions = response.suggestions;
      this.data = response.data;
      this.suggest(); 
    }
  },

  activate: function(index) {
    var divs = this.container.childNodes;
    var activeItem;
    // Clear previous selection:
    if (this.selectedIndex !== -1 && divs.length > this.selectedIndex) {
      divs[this.selectedIndex].className = '';
    }
    this.selectedIndex = index;
    if (this.selectedIndex !== -1 && divs.length > this.selectedIndex) {
      activeItem = divs[this.selectedIndex]
      activeItem.className = 'selected';
    }
    return activeItem;
  },

  deactivate: function(div, index) {
    div.className = '';
    if (this.selectedIndex === index) { this.selectedIndex = -1; }
  },

  select: function(i) {
    var selectedValue = this.suggestions[i];
    var selectedData = this.data[i];
    if (selectedValue) {
      this.el.value = selectedValue;
      if (this.options.autoSubmit && this.el.form) {
        this.el.form.submit();
      }
      this.ignoreValueChange = true;
      this.hide();
      this.onSelect(i);
    }
  },

  moveUp: function() {
    if (this.selectedIndex === -1) { return; }
    if (this.selectedIndex === 0) {
      this.container.childNodes[0].className = '';
      this.selectedIndex = -1;
      this.el.value = this.currentValue;
      return;
    }
    this.adjustScroll(this.selectedIndex - 1);
  },

  moveDown: function() {
    if (this.selectedIndex === (this.suggestions.length - 1)) { return; }
    this.adjustScroll(this.selectedIndex + 1);
  },

  adjustScroll: function(i) {
    var container = this.container;
    var activeItem = this.activate(i);
    var offsetTop = activeItem.offsetTop;
    var upperBound = container.scrollTop;
    var lowerBound = upperBound + this.options.maxHeight - 25;
    if (offsetTop < upperBound) {
      container.scrollTop = offsetTop;
    } else if (offsetTop > lowerBound) {
      container.scrollTop = offsetTop - this.options.maxHeight + 25;
    }
    this.el.value = this.suggestions[i];
  },

  onSelect: function(i) {
    if (this.options.onSelect) {
      //If you've defined "data-autocomplete_on_select" => in your autocompleter call, the selected 'suggestion' and 'data' values will be passed to it as a callback.
      eval(this.options.onSelect).bind(this)(this.suggestions[i], this.data[i]);
    }
  },

  onBlur: function() {
    if (this.options.onBlur) {
      //Define a custom onBlur action by defining "data-autocomplete_on_blur" in your view
      eval(this.options.onBlur).bind(this)();
    }
  },

  onSuggest: function() {
    if (this.options.onSuggest) {
      //Define a custom onBlur action by defining "data-autocomplete_on_suggest" in your view
      eval(this.options.onSuggest).bind(this)();
    }
  },

  onEmptySuggestions: function() {
    if (this.options.onEmptySuggestions) {
      //Define a custom action by defining "data-autocomplete_on_empty_suggestions" in your view.
      //This function will execute when a search query returns an empty suggestions array.
      eval(this.options.onEmptySuggestions).bind(this)();
    }
  }
};

Event.observe(document, 'dom:loaded', function(){ Autocomplete.isDomLoaded = true; }, false);
