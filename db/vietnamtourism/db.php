<?php
$host = "localhost";
$userName = "root";
$password = "";
$dbName = "db_vietnamtourism";
try {
	$conn = new PDO("mysql:host=$host;dbname=$dbName", $userName, $password);
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
	die("Error: " . $e->getMessage());
}
?>