window.addEventListener('load',
		function() {
			//Add click behavior to the "Settings" buttons that open a transparent overlay window
			//$("#openNewRequisitionLink").click(function() {$("#newRequisitionWindow").animate({height: "toggle"},200);});
			$("#openCardholdersLink").click(function() {$("#cardholdersWindow").animate({height: "toggle"},200);});
			$("#openCategoriesLink").click(function() {$("#categoriesWindow").animate({height: "toggle"},200);});
			$("#openPrivilegesLink").click(function() {$("#privilegesWindow").animate({height: "toggle"},200);});
                        
                        //Add click behavior to the "Close" button inside each transparent window
                        $(".closeTransparentWindowLink").click(function() {$(this).parents(".transparentWindow").animate({height: "toggle"},200);});

                        //Hide all transparent overlay windows on page load
                        $(".transparentWindow").hide();
			
			//If any hidden forms have content in their "error_explanation" divs, unhide that div.
                        //This probably means that the form was submitted with errors and the controller has kicked the user back to the form to make corrections.
			$(".transparentWindow").find("#error_explanation:parent").parents(".transparentWindow").show();

			//Add mouseover highlighting to each table row in the requisition list
			$("table.alternating-row-colors").find("tr")
                            	.mouseover(function() {
						$(this).addClass("highlight");
					   })
				.mouseout(function() {
						$(this).removeClass("highlight");
					   });
		}, false);


