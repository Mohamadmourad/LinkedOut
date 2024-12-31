<?php
header("Content-Type: application/json");

require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $jobId = $_GET['jobId'] ?? null;

    if ($jobId === null) {
        echo json_encode([
            "status" => 400,
            "message" => "Job ID is required."
        ]);
        exit;
    }
    $sql = "SELECT * FROM `applications` WHERE `jobId` = ' $jobId'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $applicants = [];
        while ($row = $result->fetch_assoc()) {
            $applicants[] = $row; 
        }

        if (count($applicants) > 0) {
            echo json_encode([
                "status" => 200,
                "data" => $applicants
            ]);
        } else {
            echo json_encode([
                "status" => 404,
                "message" => "No applicants found for the given job."
            ]);
        }
    } }

$conn->close();
