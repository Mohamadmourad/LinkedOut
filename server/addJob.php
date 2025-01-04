<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

    $name = $input["name"] ?? '';
    $description = $input["description"] ?? '';
    $skills = $input["skills"] ?? '';
    $owner = $input["owner"] ?? '';

    $sql = "INSERT INTO `jobs`(`name`, `description`, `skills`, `owner`) VALUES ('$name','$description','$skills','$owner')";
    if ($conn->query($sql) === TRUE) {
        echo json_encode([
            "status" => 200,
            "message" => "Job created successfully",
        ]);
    } else {
        echo json_encode(["status" => 500, "message" => "Error: " . $conn->error]);
    }

} else {
    echo json_encode(["status" => 403, "message" => "Invalid request method"]);
}

$conn->close();
