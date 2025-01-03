<?php 
header("Content-Type: application/json");

require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

    // Retrieve data from the decoded JSON
    $email = $input["email"] ?? '';
    $password = $input["password"] ?? '';
    $role = $input["role"] ?? '';

    $sql = "SELECT * FROM users WHERE email = '$email'";
    $result = $conn->query($sql);
    if($result->num_rows > 0) {
        echo json_encode(["status" => 403, "message" => "User already exists"]);
        exit();
    }

    $password = md5($password);
    $sql = "INSERT INTO users (email, password, role) VALUES ('$email', '$password', '$role')";

    if ($conn->query($sql) === TRUE) {
        $newUserId = $conn->insert_id; 
        echo json_encode([
            "status" => 200,
            "message" => "User created successfully",
            "user_id" => $newUserId 
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}

$conn->close();
