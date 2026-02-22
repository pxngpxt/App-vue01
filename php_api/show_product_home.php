<?php
include 'condb.php';
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

try {
    $stmt = $conn->query("SELECT * FROM products LIMIT 4");
    $datas = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$datas || count($datas) === 0) {
        echo json_encode([]);  // ✅ ส่ง array เปล่าแทน error
    } else {
        echo json_encode($datas);
    }

} catch (PDOException $e) {
    echo json_encode(["error" => $e->getMessage()]);
}
?>