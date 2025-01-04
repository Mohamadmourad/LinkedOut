<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
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
    $sql = "SELECT a.*, u.userId, u.username, u.email, u.bio
            FROM applications a
            JOIN users u ON a.applicantId = u.userId
            WHERE a.jobId = '$jobId'";
    $result = $conn->query($sql);

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode($data);
}

$conn->close();
?>