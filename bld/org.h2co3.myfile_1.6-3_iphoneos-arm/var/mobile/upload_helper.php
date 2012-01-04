<html>
	<head>
		<title>File uploaded</title>
		<style type="text/css">
		.error {
			font-weight: bold;
			color: #ff0000;
		}
		</style>
	</head>
	<body>
<?php

	$target_path = "/var/mobile/Documents/";
	$target_path = $target_path . basename ($_FILES['up_file']['name']); 

	if (move_uploaded_file ($_FILES['up_file']['tmp_name'], $target_path)) {

?>

	<p>The file has been succesfully uploaded to /var/mobile/Documents.</p>
	
<?php

	} else {
	
?>

	<p class="error">An error was encountered while uploading the file.</p>

<?php
	
	}

?>

	<p><a href="/">Root</a> <a href="upload.html">Upload another file</a></p>
	</body>
</html>

