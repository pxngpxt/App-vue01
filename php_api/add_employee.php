<?php

include 'condb.php';

$data = json_decode(file_get_contents("php://input"), true);

if (
    !isset($data['full_name']) ||
    !isset($data['department']) ||
    !isset($data['salary']) 

) {
    echo json_encode([
        "success" => false,
        "message" => "ข้อมูลไม่ครบ"
    ]);
    exit;
}

try {
    $sql = "INSERT INTO employees
            (full_name, department, salary)
            VALUES
            (:full_name, :department, :salary)";

    $stmt = $conn->prepare($sql);
    $stmt->execute([
        ':full_name' => $data['full_name'],
        ':department'  => $data['department'],
        ':salary'     => $data['salary']
    ]);

    echo json_encode([
        "success" => true,
        "message" => "เพิ่มข้อมูลเรียบร้อย"
    ]);

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}
