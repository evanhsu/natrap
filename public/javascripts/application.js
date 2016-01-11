// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function getDataAttributes(element, options) {
  /*
  returns a hash of all of element's attribute/value pairs where the
  attribute name begins with "data-".  Set options.removePrefixes to true
  in order to remove the "data-" prefix from the returned hash's keys.
  */
  if(!options) options = {};
  var attributes = element.attributes;
  var dataAttributes = new Object;
  var attrNames = new Array();
  //collect all of element's attribute names
  for(var n=0; n<attributes.length; n++) {
    attrNames.push(attributes[n].name);
  }
  //keep only the ones that are prefixed with 'data-'
  attrNames = attrNames.grep(/^(data\-)/);
  //save those attributes and their values in dataAttributes
  for(var n=0; n<attrNames.length; n++) {
    var attr1 = attrNames[n];
    var attr2 = attr1;
    if(options["removePrefixes"]) {
      attr2 = attr1.replace(/^(data\-)/, "");
    }
    dataAttributes[attr2] = element.readAttribute(attr1);
  }
  return dataAttributes;
}

String.prototype.camelCase = function() {
  //converts under_score to camelCase
  return this.replace(/_[a-z]/g, function($1) {return $1.toUpperCase().replace("_", "");});
}

String.prototype.underscore = function() {
  return this.replace(/([A-Z])/g, function($1){return "_"+$1.toLowerCase();});
}

String.prototype.typify = function() {
  //converts a string to its "intended" type.
  //i.e. "123" becomes an integer, "true" becomes a boolean
  //convert integers
  if(this.match(/^\d+$/)) {
    return parseInt(this);
  }
  //convert booleans
  else if(this.match(/^(true)$/)) {
    return true;
  }
  else if(this.match(/^(false)$/)) {
    return false;
  }
  return this.valueOf();
}

function typifyStringValues(obj) {
  //returns a copy of obj with all string values typified.
  var temp = new Object;
  for(key in obj) {
    if(typeof(obj[key]) == "string") {
      temp[key] = obj[key].typify();
    }
    else {
      temp[key] = obj[key];
    }
  }
  return temp;
}

function camelCaseKeys(obj) {
  //returns a copy of obj with all keys converted from under_scored to camelCase
  var temp = new Object;
  for(key in obj) {
    temp[key.camelCase()] = obj[key];
  }
  return temp;
}

function getKeys(obj) {
  var arr = [];
  for(var key in obj) {
    arr.push(key);
  }
  return arr;
}

function getValues(obj) {
  var arr = [];
  for(var key in obj) {
    arr.push(obj[key]);
  }
  return arr;
}

function slideDownInsert(elementId, content) {
  var wrapper = new Element('div', {'style': 'display:none'}).insert(new Element('div').update(content));
  $(elementId).insert({top: wrapper});
  new Effect.SlideDown(wrapper);
}

