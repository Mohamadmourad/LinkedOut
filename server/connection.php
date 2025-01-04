<?php
$conn = new mysqli("sql113.infinityfree.com", "if0_38027156", "xvBSIC8Uqp", "if0_38027156_linkedout");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}