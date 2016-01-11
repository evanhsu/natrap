// This script accompanies the autocompleter on the 'edit crew roster' page
// (/admin/crews/1/roster/2013).
// If a name is typed into the autocomplete field that does not return any
// suggestions, this script will generate a link to the 'create new person' form
// with the 'name' fields pre-populated.

function linkToCreatePerson() {
    if(Autocomplete.instances[0].el.value.length > Autocomplete.instances[0].options.minChars) {
        //Autocomplete.instances[0].suggestions[0] = 'hello';
        console.log(Autocomplete.instances[0]);
    } // End: if(Autocomplete.instances[0].el.value.length...
} // End: function linkToCreatePerson(name)