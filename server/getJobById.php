<?php
header("Content-Type: application/json");

require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $ownerId = $_GET['id'] ?? null;

    if ($ownerId === null) {
        echo json_encode([
            "status" => 400,
            "message" => "Owner ID is required."
        ]);
        exit;
    }

    $sql = "SELECT * FROM `jobs` WHERE `owner` = '$ownerId'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $jobs = [];
        while ($row = $result->fetch_assoc()) {
            $jobs[] = $row; 
        }
        echo json_encode([
            "status" => 200,
            "data" => $jobs
        ]);
    } else {
        echo json_encode([
            "status" => 404,
            "message" => "No jobs found for the given owner."
        ]);
    }
} else {
    echo json_encode([
        "status" => 403,
        "message" => "Invalid request method. Only GET is allowed."
    ]);
}

$conn->close();
