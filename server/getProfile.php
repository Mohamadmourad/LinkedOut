<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    $userId = $_GET["userId"] ?? '';
    if (empty($userId)) {
        echo json_encode(["status" => 400, "message" => "Missing userId"]);
        exit();
    }
    $sql = "SELECT username, bio FROM users WHERE userId = '$userId'";
    $result = $conn->query($sql);
    if ($result && $result->num_rows > 0) {
        $userData = $result->fetch_assoc();
        $skills = [];
        $skillsQuery = "SELECT skill FROM skills WHERE userId = '$userId'";
        $skillsResult = $conn->query($skillsQuery);
        while ($row = $skillsResult->fetch_assoc()) {
            $skills[] = $row['skill'];
        }
        echo json_encode([
            "status" => 200,
            "user" => [
                "username" => $userData["username"],
                "bio" => $userData["bio"],
                "skills" => $skills
            ]
        ]);
    } else {
        echo json_encode(["status" => 404, "message" => "User not found"]);
    }
} else {
    echo json_encode(["status" => 403, "message" => "Invalid request method"]);
}

$conn->close();
?>