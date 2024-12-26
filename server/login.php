<?php
header("Content-Type: application/json");

require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

    $email = $input["email"] ?? '';
    $password = $input["password"] ?? '';

    if (empty($email) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Email and password are required."]);
        exit();
    }

    $result = $conn->query("SELECT * FROM users WHERE email = '$email' AND password = '$password'");

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

            echo json_encode([
                "status" => 200,
                "message" => "Login successful",
                "user" => [
                    "id" => $user["id"],
                    "email" => $email,
                    "role" => $user["role"]
                ]
            ]);
        
    } else {
        // User not found
        echo json_encode(["status" => 404, "message" => "Invalid email or password."]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}

$conn->close();
