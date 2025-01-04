<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require_once "connection.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $input = json_decode(file_get_contents("php://input"), true);

    $userId = $input["userId"] ?? '';
    $name = $input["name"] ?? '';
    $bio = $input["bio"] ?? '';
    $skillInput = $input["skill"] ?? [];
    if (!is_array($skillInput)) {
        $skillInput = [$skillInput];
    }


    $sqlUser = "UPDATE `users` SET `username`='$name', `bio`='$bio' WHERE `userId`='$userId'";
    if ($conn->query($sqlUser) === TRUE) {


        $sqlDeleteSkills = "DELETE FROM `skills` WHERE `userId`='$userId'";
        if ($conn->query($sqlDeleteSkills) !== TRUE) {
            echo json_encode(["status" => 500, "message" => "Error: " . $conn->error]);
            exit;
        }


        foreach ($skillInput as $s) {
            $sqlSkill = "INSERT INTO `skills` (`userId`, `skill`) VALUES ('$userId', '$s')";
            if ($conn->query($sqlSkill) !== TRUE) {
                echo json_encode(["status" => 500, "message" => "Error: " . $conn->error]);
                exit;
            }
        }
        echo json_encode([
            "status" => 200,
            "message" => "Profile updated successfully",
        ]);

    } else {
        echo json_encode(["status" => 500, "message" => "Error updating user: " . $conn->error]);
    }

} else {
    echo json_encode(["status" => 403, "message" => "Invalid request method"]);
}

$conn->close();
?>