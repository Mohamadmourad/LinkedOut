<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "connection.php";


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = $_POST['userId'];
    $jobId = $_POST['jobId'];


    if (!empty($userId) && !empty($jobId)) {
        $date = date('Y-m-d');


        $stmt = $conn->prepare("INSERT INTO applications (jobId, applicantId, dateOfApplication) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $jobId, $userId, $date);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Application submitted successfully."]);
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to submit application."]);
        }

        $stmt->close();
        $conn->close();
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid input."]);
    }
}

?>