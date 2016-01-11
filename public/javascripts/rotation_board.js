(function() {
	var board;
	var newRowCreated = false; //Global var used in the Board.prototype.onOver function
	var newRow = null;
        var roBoPositions; //This will hold the personId and row/col of each draggable on the board 
	var crewId; //This will be set from the hidden div #crew_id after the page has loaded

        window.addEventListener('load',
		function() {
			//Set the board state to the most current state in the database and animate each person's draggable onto the Board.
			crewId = $("#crew_id").text();
			board.setStateTo("current");
			
			//Add click behavior to the forward/back 'player controls' buttons at the top of the page
			$("#roBoBackArrow").click(function() {board.setStateTo("previous");});
			$("#roBoForwardArrow").click(function() {board.setStateTo("next");});
		}, false);
	
	$(function() {
		board = new Board($('.list'));
                refreshEditables(); //Construct in-place editors on the appropriate DIVs
	});

	
	function Board(element, options) {
		var self = this;
		this.$element = $(element);
		this.selector = this.$element.selector;
		this.listId = self.$element.attr('id');
                this.settings = options || {};
		this.settings = $.extend({
			rowSelector: '.row',
			cellSelector: '.cell',
			draggableSelector: '.draggable',
                        ajax_post_url: 'rotation_board' // POST domain.com/rotation_board
		}, this.settings);

		
		this.refreshDraggables = function() {
                        var rowSelector = this.settings.rowSelector;
                        var draggableSelector = this.settings.draggableSelector;
                        var cellSelector = this.settings.cellSelector;

			$(draggableSelector).draggable({
				helper: 'clone', //Must use a clone in order for the 'connectToSortable' property to work
				opacity: 1.0,
				revert: false,
				snap: cellSelector,
				snapMode: 'inner',
				start: $.proxy(this.onStartDrag, this),
				stop: $.proxy(this.onStopDrag, this)
			});
					
			$(cellSelector).droppable({
				drop: $.proxy(this.onDrop, this),
				over: $.proxy(this.onOver, this),
				tolerance: 'pointer'
			});
			
			this.$element.each(function(listIdx,thisList) {
                            //Do this for each '.list' on the page ('unassigned-list' & 'assigned-list')
                            $(thisList).find(rowSelector).each(function(idx, el) {
				$(el).attr('data-row',parseInt(idx));//Assign row numbers dynamically
                                $(el).children(cellSelector).each(function(colIdx,cell) {
                                    $(cell).attr('data-col',parseInt(colIdx));//Assign col numbers dynamically
                                });
                            });
                        });
		};
		this.refreshDraggables();
	} // End function Board()


	Board.prototype.onDrop = function(event, ui) {
		//When this draggable is dropped onto a drop target, remove the draggable from 
		//its parent and append it to the current drop target. 
		//NOTE: a drop event may not fire if a draggable is strictly moved vertically since the swapRows() function
		//repositions the original element as it's moved. Any horizontal movement and subsequent drop onto
		//a droppable zone will result in a drop event.
		$(event.target).append(ui.draggable.detach().css({'position':'relative','left':'0','top':'0'}));

                //Remove all hidden rows from the DOM (rows may have been hidden if draggables moved from one list to another)
                //console.log("Removing hidden rows");
                $(this.selector).find(this.settings.rowSelector+":hidden").remove();
                this.refreshDraggables();
                refreshEditables();

		if(newRowCreated) {
			//A new row of drop targets has been cloned into the board during this drag event.
			newRowCreated = false; //Reset this flag from the onOver function
			newRow = null;
		}

                //Build an array of objects describing the position of each person on the board
                var roBoPositions = this.buildRoBoPositionsArray();
	}
	
	Board.prototype.onOver = function(event, ui) {
		//When a droppable 'cell' is dragged over, do the following:
		// 1. Insert a blank row of cells (drop targets) 
		// 2. Detach the current draggable from its parent and append it to a cell in the new row
		var thisRow = $(event.target).parent();
		var thisRowIdx = this.getRowIndex($(event.target));
		var draggedRow = ui.draggable.parents(this.settings.rowSelector);
		var draggedRowIdx = this.getRowIndex(ui.draggable);
		var thisColIdx = this.getColIndex($(event.target));
		var draggedColIdx = this.getColIndex(ui.draggable);
		var targetCellIdx = $(this.settings.cellSelector).index($(event.target));
		var sourceCellIdx = $(this.settings.cellSelector).index(ui.draggable.parent());
		var overBoard = $(event.target).parents(this.selector);
		var overBoardId = overBoard.attr('id');
		var fromBoard = ui.draggable.parents(this.selector);
		var fromBoardId = fromBoard.attr('id');
		var dragHelper = ui.draggable.siblings(this.settings.draggableSelector);
		
		//Create a new empty row, if needed
		if((fromBoardId != overBoardId) ) {
			//A draggable has been moved from one list to another.
			//Create a new row on the new list and remove the empty row from the old list.
			
			//Insert a new blank row into the new list, unless there is already a blank row
                        //Determine if there is already a blank row
                        var draggableCount = $(overBoard).find(this.settings.draggableSelector).length; //Count the number of draggables in this list
                        if(draggableCount > 0) {
                            //Find the rowTemplate for this list, clone it, insert it into the list above the row being hovered over.
                            newRow = overBoard.find('.rowTemplate').clone().removeClass('rowTemplate').addClass('row').insertBefore(thisRow);
                        }
                        else {
                            newRow = thisRow;
                        }
                        //Append the current draggable to the newly-created row (inside the cell being hovered over)
                        //Also move the drag helper to the new row so it doesn't get destroyed along with the empty row
                        var newTargetCell =  newRow.children('.cell:nth-child('+(parseInt(thisColIdx)+1)+')');
                        newTargetCell.append(ui.draggable.detach());
                        newTargetCell.append(dragHelper.detach());

			//Remove the empty row from the old list unless it's the last row
                        //If its the last row, re-enable the droppable property (since it was disabled
                        //when the drag event started - onStartDrag)
                        var emptyRowSelector = "[data-row='"+$(draggedRow).attr('data-row')+"']";
			var remainingRows = $(fromBoard).children(".row").not(emptyRowSelector).length;
                        if(remainingRows > 0) draggedRow.hide(200);
                        else $(draggedRow).find(this.settings.cellSelector).droppable('enable');

                        //Update all indeces
                        this.refreshDraggables();
			$.ui.ddmanager.prepareOffsets(ui.draggable.draggable('instance'), event );
                        
			newRowCreated = true; //This gets reset on a DROP event
		}
		else if(thisRowIdx != draggedRowIdx ) {
                        //If the draggable has been moved over a different row than its parent row, move its parent row.
                        //This function won't be called if the different row is also part of a different list.
			this.swapRows(overBoardId, thisRowIdx, draggedRowIdx, event);
                        this.refreshDraggables();
		}
	}
	
	Board.prototype.onStartDrag = function(event, ui) {
            //Disabling the parent droppable causes a bug: when the last item on a list is dragged
            //to another list (and immediately appended) then back during the same drag event, the
            //draggable cannot be placed back into its original list.
            //Fix: the original parent droppable is re-enabled whenever a new row is created in the 'over' handler.
            $(event.target).parents(this.settings.cellSelector).droppable('disable');

            //Hide the original element so that only the drag helper is visible
            $(event.target).css("visibility","hidden");
		
	}
	
	Board.prototype.onStopDrag = function(event, ui) {
	    var changedPersonId = $(event.target).attr('data-person-id');
	    var changeType = 'move';
            $(this.settings.cellSelector).droppable('enable'); //Re-enable dropping on ALL cells
            //Restore visibility to the original element now that the drag helper is going to disappear
            $(event.target).css("visibility","visible");
	    this.saveState(changeType,changedPersonId); //Save the board state to the database via AJAX
	}
	
	Board.prototype.getRowIndex = function(element) {
		var index;
                /*
		var targetId = $(element).attr('data-row');
		if (targetId === undefined) {
			targetId = $(element).parents(this.settings.rowSelector).attr('data-row');
			if (targetId === undefined) {
				console.error('row missing data-row attribute');
			}
		}
		//console.error(this.rows);
		for (var n = 0; n < this.rows.length; n++) {
			if (this.rows[n] === targetId) {
				index = n;
			}
		};
                */
                index = $(element).parents(this.settings.rowSelector).attr('data-row');
                return index;
	}
	
	Board.prototype.getColIndex = function(element) {
		//Returns the numerical column containing the 'element' (zero-indexed)
		//'element' could be a droppable cell or a draggable item.
		var colIndex;
		var cellSelector = this.settings.cellSelector;
		var parentRow = $(element).parents(this.settings.rowSelector);
                var targetIdx= $(cellSelector).index($(element));

		if (targetIdx == -1) {
			targetIdx = $(cellSelector).index($(element).parents(cellSelector));
			if (targetIdx == -1) {
				console.error('Cell has no index');
			}
		}
		//Find the parent row, count through the child 'cells' until this element matches one
		parentRow.children(cellSelector).each(function(idx,el) {
			if(targetIdx == $(cellSelector).index($(el))) {
				colIndex = idx;
			}
		});
		return colIndex;
	}

	Board.prototype.swapRows = function(listId, targetRowId, draggedRowId, event) {
            //console.log("Swapping Rows");
		//var targetId = this.rows[targetRowIdx];
		//var draggedId = this.rows[draggedRowIdx];
		var targetEl, draggedEl;
            /*
		$(listId).find(this.settings.rowSelector).each(function(idx, el) {
			if ($(el).attr('data-row') === targetRowId) {
				targetEl = $(el);
			} else if ($(el).attr('data-row') === draggedRowId) {
				draggedEl = $(el);
			}
		});
            */
                targetEl =  $(this.selector+"[id='"+listId+"']").find(this.settings.rowSelector+"[data-row='"+targetRowId +"']");
                draggedEl = $(this.selector+"[id='"+listId+"']").find(this.settings.rowSelector+"[data-row='"+draggedRowId+"']");
		draggedEl = draggedEl.detach();
		if (parseInt(draggedRowId) < parseInt(targetRowId)) {
                        draggedEl.insertAfter(targetEl);
		} else {
			draggedEl.insertBefore(targetEl);
		}

		$.ui.ddmanager.prepareOffsets( draggedEl.find(this.settings.draggableSelector).draggable('instance'), event );
	}

        Board.prototype.buildRoBoPositionsArray = function() {
		//Build a hash of objects describing the position of each draggable on the board
		//Structure:
		//	{"RoBoState":
		//		{"crew_id":1,
		//		"user_id":24,
		//		"username":"johndoe"
		//		}
		//	},
		//	{"RoBoPositions":
		//		{"personId":1,
		//		"listId":"unassigned-list",
		//		"row":2,
		//		"col":0,
		//		"role":"Chase COP",
		//		"rank":3
		//		},
		//		{"personId":2,
		//		"listId":"unassigned-list",
		//		"row":3,
		//		"col":0,
		//		"role":"HMGB",
		//		"rank":4
		//		}
		//	}

		var roBoStateObject = {};
		var roBoPositionsArray = [];

		roBoStateObject = {"crew_id":crewId, "user_id":0, "username":"fakeUsername"}; //user info is populated by the Rails controller to avoid tampering
		$(':root .draggable:not(.ui-draggable-dragging)').each(function(idx,el) {
		roBoPositionsArray.push(
		{"personId":$(el).attr('data-person-id'),
		 "listId":$(el).parents('.list').attr('id'),
		 "row":$(el).parents('.row').attr('data-row'),
		 "col":$(el).parents('.cell').attr('data-col'),
		 "role":$(el).parents('.row').children('.role-cell').text(),
		 "rank":$(el).parents('.row').children('.rank-cell').text()
		});
		});
		return {"RoBoState":roBoStateObject,"RoBoPositions":roBoPositionsArray};
        }

   	Board.prototype.setStateTo = function(state) {
		//Make an AJAX GET request to retrieve the 'roBoPositions' array which will be
		//used to place each person in the correct spot on the page.
		var ajaxUrl, renderFunc;
		switch(state) {
			case "next":
				//When the 'next' or 'previous' board state is requested, determine what changed and animate the existing
				//draggables to their new positions (don't reload all roBoPosition objects).
				ajaxUrl = "/rotation_board/"+$("#roBoStateId").text()+"/next.json"
				renderFunc = "updatePositions";
				break;
			case "previous":
				//When the 'next' or 'previous' board state is requested, determine what changed and animate the existing
				//draggables to their new positions (don't reload all roBoPosition objects).
				ajaxUrl = "/rotation_board/"+$("#roBoStateId").text()+"/previous.json"
				renderFunc = "updatePositions";
				break;
			case "current":
			default:
				//When the 'current' state is requested, perform a full query to load all people with a roBoPosition, then load
				//people on the current crew roster, even if they don't have a roBoPosition associated with this roBoState.
				ajaxUrl = "/crews/"+crewId+"/robo.json"
				renderFunc = "loadPositions";
				break;
		}
			
		var result = $.ajax({
				    url: ajaxUrl,
				    async: true,
				    type: 'GET',
				    context: this,
				    success: 	function(roBoPositions) {
							this[renderFunc](roBoPositions); //Send the positions array to be drawn on the page
							//this.renderPositions(roBoPositions); //Send the positions array to be drawn on the page.
							//If the roBoState currently being displayed is not the most recent state in the database,
							//disable dragging
							if(roBoPositions.positions[0].roBoStateId != roBoPositions.currentRoBoState.id) {
								$(this.settings.draggableSelector).draggable('disable');
							}
						}
				});

		
		

    	}

	Board.prototype.loadPositions = function(boardSnapshot) {
/*		boardSnapshot = {
				positions: {
						0: { 
							ro_bo_position: {
									id: 
									row: 
									col:
									personId:
									person_name:
									person_quals:
									person_headshot_url:
									listId:
									etc.... 
							}
						}
						1: {
							ro_bo_position: {
									etc....
							}
						}
				} // End 'positions' hash
				currentRoBoState: {
						ro_bo_state: {
							id:
							crew_id:
							user_id:
							username:
						}
				} // End 'currentRoBoState' hash
		} // end 'boardSnapshot' hash
*/
		var newRoBoPositions = boardSnapshot.positions;
		var currentRoBoState = boardSnapshot.currentRoBoState;

		console.error(newRoBoPositions);
		console.log(currentRoBoState);

		//Input: newRoBoPositions is an array of RoBoPosition objects in JSON format describing the row/col of each person on the board
		if(newRoBoPositions.length > 0) {
			$('#roBoStateId').text(newRoBoPositions[0].roBoStateId);
			//Get the timestamp for this roBoState and display it in the user's timezone
			var update_time = new Date(newRoBoPositions[0].updated_at); 
			$('#roBoTime').text($.formatDateTime('mm-dd-yy hh:ii',update_time));
		}
		var position, newRow, targetCell, targetDrag, lists;

		//Remove the current draggables so we don't create duplicates
		//Animate the key draggable to its new position, then remove draggable property from all draggables to prevent an out-of-date board from generating POST updates.
		
		//If the request is for the current board state, place all roBoPositions and then append unhandled roster entries.
		for(var i=0;i<newRoBoPositions.length;i++) {
			//Iterate through all the people who need to be placed on the board and create an empty row on the appropriate list.
			position = newRoBoPositions[i];
			//Copy the row template into the specified list
			newRow = $("#"+position.listId).find('.rowTemplate').clone().removeClass('rowTemplate').addClass('row');
			newRow.appendTo($("#"+position.listId));
			newRow.attr("data-row",position.row);
			
			targetCell = newRow.children(".cell[data-col='"+position.col+"']");
			//Copy the Draggable template into the newly-created row/col and then insert the person data into the draggable
			targetDrag = $(":root").find('.draggableTemplate').clone().removeClass('draggableTemplate').addClass('draggable ui-draggable ui-draggable-handle').appendTo(targetCell);
			targetDrag.attr("data-person-id",position.personId);
			targetDrag.children(".personName").text(position.person_name);
			targetDrag.children(".personQuals").text(position.person_quals);
			targetDrag.children(".headshot").attr("src","/images/"+position.person_headshot_url);
			//targetDrag.children(".headshot").attr("alt",position.person_name);
			
			//Insert the ROLE and RANK data into the person's row.
			newRow.find(".role-cell > .editable").text(position.role);
			newRow.find(".rank-cell > .editable").text(position.rank);
		}
		//If either of the lists is blank (contains no people), create a blank row to provide a droppable area.
		lists = $(this.selector);
		for(var i=0;i<lists.length;i++) {
			if($(lists[i]).find(".row").length == 0) {
				//There are no rows in this list - append 1 copy of this list's rowTemplate
				newRow = $(lists[i]).find('.rowTemplate').clone().removeClass('rowTemplate').addClass('row').appendTo($(lists[i]));
				newRow.attr("data-row","0");
			}
		}
		
		this.refreshDraggables(); //Assign row numbers to all the empty rows we just added
		refreshEditables(); //Activate the in-place editor fields.

	}

	Board.prototype.updatePositions = function(boardSnapshot) {
		//This function animates the change between the board state currently on-screen and the requested board state (previous or next).
		//This is done by determining which of the following possible changes were made:
		//	1. Person was created or destroyed
		//	2. Person was dragged from one cell to another.
		var change = {	type: boardSnapshot.roBoState.changeType,
				personId: boardSnapshot.roBoState.changePersonId};
		switch(change.type) {
			case 'create':
			
				break;
			case 'destroy':
				
				break;
			case 'move':
				
				break;
		}

	}//End function updatePositions

	Board.prototype.saveState = function(changeType,changedPersonId) {
		//POST the current position of each person to the Rails controller to store in the database.
		//Also take note of which person was changed and whether he was created,destroyed or moved.
		var roBoPositions = this.buildRoBoPositionsArray();
		roBoPositions.RoBoState['change_type'] = changeType;
		roBoPositions.RoBoState['changed_person_id'] = changedPersonId;

		console.error(roBoPositions);

		$.ajax({
                    url: this.settings.ajax_post_url,
		    //url: "crews/"+$("#crew_id").text()+"/rotation_board",
                    type: 'POST',
                    datatype: 'json',
                    data: roBoPositions,
                    success: function() {
//				console.log(JSON.stringify(roBoPositions));	
			}
                });	
	}

	function refreshEditables() {
            //Implement the jEditable plugin to create in-place editable fields
            //<div class='editable'>Click Here</div>
            $('.editable').editable(function(value,settings){
                        $(this).text(value);
                    }, {
                     style : 'font-weight:bold',
                     indicator : 'Saving...',
                     tooltip : 'Click to edit',
                     placeholder : '',
                     onblur : 'submit',
                     callback: function(value,settings) {
                                    board.saveState();
                                  }
			});
        } //End function refreshEditables()

    
    function loadNewPersonIfNeeded(oldPositions,newPositions) {
        //Check to see if a new person has been added to the board between
        //the previous board-state and the current board-state.
        //If so, grab the person's Name, Quals and Headshot image URL.
        //If not, return false.
        //
        //input parameters should each be an array of objects, i.e.
        // newPositions =  [{personId:6, row:3, col:0, listId:"unassigned-list"},
        //                  {personId:8, row:4, col:0, listId:"unassigned-list"}]
        var i,j,findPersonId,newPerson;
        var match=false;
        var newPersonFound=false;
        
        for(i=0;i<newPositions.length();i++) {
            findPersonId = newPositions[i].personId;
            for(j=0;j<oldPositions.length();j++) {
                if(oldPositions[j].personId == findPersonId) {
                    match = true;
                    return; //Break this loop when a match is found
                }
            }//End for(j=0;j<oldPositions...
            if(!match) {
                newPersonFound = true;
                return;
            }
        }//End for(i=0;i<newPositions...
        if(newPersonFound) {
            //Make an AJAX request to retrieve this person's info
            newPerson = $.ajax({
                url: "/people/"+findPersonId,
                data: {datafor: "roBo"}, //We only want the info needed for the rotation board, not the entire Person object
                async: true,
                method: "GET"
            });
            //onSuccess: create a new draggable tile
        }
    }//End function loadNewPersonIfNeeded()

    function fitText(elem) {
        //console.error($(elem).contents().css("width"));
        //console.error($(elem).width()+","+$(elem).parent().width());
      var fontstep = 2;
      if ($(elem).height()>$(elem).parent().height()-4 || $(elem).width()>$(elem).parent().width()-4) {
        $(elem).css('font-size',(($(elem).css('font-size').substr(0,2)-fontstep)) + 'px').css('line-height',(($(elem).css('font-size').substr(0,2))) + 'px');
        fitText(elem);
      }
    }
})();

// To-Do List
//
// Draggables must be able to move back and forth between the unassigned-list and the assigned-list.
// User-assignable "roles" (First Load, 1234, Chase COP, etc)
// Add new people to the list (NOT loaded from database, but new arbitrary people created on-page).
// Comments for people on the assigned-list.
// Column counter (how many people are 'Available').
// History (step backwards through recent drag/drop actions. animated)
//	-Database should store unique cell index for each draggable (NOT a row/col relative to the element's list).
//	-When a st
// Filter by qualification, highlight matches
//
//How to animate a draggable to a new position:
// -Get the coordinates of the target location
// -Set the draggable to absolute positioning and then set the 'top' & 'left' properties to its current position.
// -Use the jQuery .animate() method to set the draggable's position to the target coordinates
// -Use the completion callback on the .animate() method to detach() and append() the draggable into the target once the animation finishes.
/*
	el = $('.row[data-row="2"]').find('.draggable'); // The element to be moved
	target = $('.row[data-row="3"]').find('.cell[data-status="unavailable"]'); // The target droppable
	newPos = target.offset(); // The coordinates of the target: newPos.left & newPos.top

	el.css({"position":"absolute", top:el.offset().top, left:el.offset().left}); //el doesn't move, but position is now absolute
	el.animate(
		{top:newPos.top, left:newPos.left},
		function() {
			//Animation complete
			$.ui.ddmanager.prepareOffsets(el.draggable('instance'), event );
			target.append(el.detach());
		}); 
*/
