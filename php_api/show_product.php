<?php
include 'condb.php';
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$id = $_GET['id'] ?? null;

if (!$id) {
    echo json_encode(["success" => false, "message" => "ไม่มี id"]);
    exit;
}

try {
    $stmt = $conn->prepare("SELECT * FROM products WHERE product_id = ?");
    $stmt->execute([$id]);
    $product = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($product) {
        echo json_encode(["success" => true, "data" => $product]);  // ✅ format ที่ Vue คาดหวัง
    } else {
        echo json_encode(["success" => false, "message" => "ไม่พบสินค้า"]);
    }
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => $e->getMessage()]);
}
?>