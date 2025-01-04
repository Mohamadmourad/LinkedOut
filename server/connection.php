<?php
$conn = new mysqli("192.168.0.234", "root", "00123mysql", "linkedout", 3306);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
