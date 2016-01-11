// Add behavior to the menu bar

$(function() {
	var menu = new Menu($('.menubar'));
});


function Menu(element,options) {
	element.find("li>ul").hide(); // Hide all submenus on load

	element.children("li").click(function() {
		//A top-level menu button has been clicked

		//Clear styling on any buttons or submenus that were previously active
		$(this).siblings("li").removeClass('menu-button-with-active-submenu');
		$(this).siblings("li").children("ul").hide();

		//Add 'active' styling to the current top-level menu button and show its submenu
		$(this).children("ul").show(); // Show submenu when the parent <li> is clicked
		$(this).addClass('menu-button-with-active-submenu'); //Keep the parent button 'lit up' while the submenu is active, even if the cursor is not hovering over it

	/*	a = $(this).find("a").prop("href");
		b = window.location.href;
		alert(a + "::" + b);
	*/
	}); //End click()


	//Add hover effect to all menu buttons
	element.find("li").hover(function() {
		$(this).addClass('menu-button-focus'); //mouseEnter action
		}, function() {
		$(this).removeClass('menu-button-focus'); //mouseLeave action
	}); //End hover()

	//Add click listener to the entire document that will collapse open menus when the user clicks elsewhere on the page
	$('html').click(function(event) {
		//Collapse all open menus, unless the menu was clicked on
		if(element.find(event.target).length == 0) {
			element.children("li").removeClass('menu-button-with-active-submenu');
			element.find("li > ul").hide();
		}
		
	}); //End click()



} // End function Menu()