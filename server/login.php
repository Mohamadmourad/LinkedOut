<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
error_reporting(E_ALL);
ini_set("display_errors", 1);

require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

    $email = $input["email"] ?? '';
    $password = $input["password"] ?? '';

    if (empty($email) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Email and password are required."]);
        exit();
    }

    $password = md5($password);

    $result = $conn->query("SELECT * FROM users WHERE email = '$email' AND password = '$password'");

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        echo json_encode([
            "status" => 200,
            "message" => "Login successful",
            "user" => [
                "id" => (int) $user["userId"],
                "email" => $email,
                "role" => $user["role"]
            ]
        ]);

    } else {

        echo json_encode(["status" => 404, "message" => "Invalid email or password."]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method."]);
}

$conn->close();
