<?php

/***********************************************************************************/
/***********************************************************************************/
/***********************************************************************************/
function bad_image($msg) {
	$img = imagecreatetruecolor (270, 300); /* Create a blank image */
	$bgc = imagecolorallocate ($img, 255, 255, 255);
	$tc = imagecolorallocate ($img, 50, 150, 50);
	imagefilledrectangle ($img, 0, 0, 325, 400, $bgc);
	/* Output an errmsg */
	imagestring ($img, 2, 5, 50, $msg, $tc);
	header('Content-Type: image/gif');
	imagegif($img);
	exit;
}

/***********************************************************************************/
/***********************************************************************************/
/***********************************************************************************/

$input_array = $_GET['q']; // 'q' is a CSV list of the number of raps from each seat (Seat #0 - #9)
$raps_per_seat = explode(',',$input_array);

$helicopter_img_filename = "../images/fav_position.png";

// Load the background image
$helicopter = @imagecreatefrompng($helicopter_img_filename);
if(!$helicopter) bad_image("Error loading ".$helicopter_img_filename);

// Define the starting coordinates for each of the text fields in the image
// These coordinates will be adjusted depending on the number of digits that
// need to fit into the text field
// Seats are numbered as follows (this number corresponds to 'seat_num' in the $raps_by_seat array):
/*------------------------------------------------------
			 MEDIUM						LIGHT
	0		1		2		3

		4				5				8	9

		6				7

--------------------------------------------------------*/
$seat_coords = array(
					 array('x'=>21,'y'=>84),	/* 0: Medium Bench Stick 1 Left (same as Medium Hellhole Stick 1 Left) */
					 array('x'=>50,'y'=>84),	/* 1: Medium Bench Stick 2 Left  */
					 array('x'=>80,'y'=>84),	/* 2: Medium Bench Stick 2 Right  */
					 array('x'=>110,'y'=>84),	/* 3: Medium Bench Stick 1 Right (same as Medium Hellhole Stick 1 Right)  */
					 array('x'=>35,'y'=>131),	/* 4: Medium Bench Stick 3 Left (same as Medium Hellhole Stick 2 Left)  */
					 array('x'=>93,'y'=>131),	/* 5: Medium Bench Stick 3 Right (same as Medium Hellhole Stick 2 Right)  */
					 array('x'=>35,'y'=>159),	/* 6: Medium Hellhole Stick 3 Left  */
					 array('x'=>93,'y'=>159),	/* 7: Medium Hellhole Stick 3 Right  */
					 array('x'=>187,'y'=>97),	/* 8: Light Stick 1 Left  */
					 array('x'=>228,'y'=>97)	/* 9: Light Stick 1 Right  */
					 );


// Define the font color
$fc = imagecolorallocate ($helicopter, 50, 50, 50);

$seat_num = 0;
foreach($raps_per_seat as $rap_count) {
	$x = $seat_coords[$seat_num]['x'];
	$y = $seat_coords[$seat_num]['y'];

	$x = $x - 4 * (strlen($raps_per_seat[$seat_num]) - 1); // Move the starting point LEFT 4 pixels for each digit in excess of 1
	imagestring ($helicopter, 4, $x, $y, $raps_per_seat[$seat_num], $fc);
	$seat_num++;
}


// Write finished image to browser
header('Content-Type: image/png');
imagepng($helicopter);

?>