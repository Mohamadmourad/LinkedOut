<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $sql = "SELECT * FROM `jobs` LEFT JOIN 'applications' on jobs.jobId = applications.jobId WHERE applications.jobId IS NULL";
    
    $result = $conn->query($sql);
    $jobs = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $jobs[] = $row;
        }
    }
    echo json_encode([
        "status" => 200,
        "data" => $jobs
    ]);
} else {
    echo json_encode([
        "status" => 405,
        "message" => "Method Not Allowed"
    ]);
}
?>