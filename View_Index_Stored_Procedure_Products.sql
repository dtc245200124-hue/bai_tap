-- [Bài tập] View, Index, Stored Procedure
-- Bảng thực hành: Products

-- ============================================================
-- BƯỚC 1: Tạo cơ sở dữ liệu demo
-- ============================================================
CREATE DATABASE IF NOT EXISTS product_management;
USE product_management;

-- Xóa bảng cũ để có thể chạy lại toàn bộ bài từ đầu.
DROP TABLE IF EXISTS Products;

-- ============================================================
-- BƯỚC 2: Tạo bảng Products và dữ liệu mẫu
-- ============================================================
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12, 2) NOT NULL,
    productAmount INT NOT NULL DEFAULT 0,
    productDescription VARCHAR(255),
    productStatus BIT NOT NULL DEFAULT 1
);

INSERT INTO Products (
    productCode,
    productName,
    productPrice,
    productAmount,
    productDescription,
    productStatus
)
VALUES
    ('P001', 'Laptop Dell Inspiron', 18500000, 10, 'Laptop văn phòng', 1),
    ('P002', 'Laptop HP Pavilion', 17200000, 8, 'Laptop học tập', 1),
    ('P003', 'Chuột Logitech M331', 450000, 50, 'Chuột không dây', 1),
    ('P004', 'Bàn phím Logitech K120', 250000, 35, 'Bàn phím USB', 1),
    ('P005', 'Màn hình Samsung 24 inch', 3900000, 15, 'Màn hình Full HD', 1),
    ('P006', 'Tai nghe Sony WH-CH520', 1290000, 20, 'Tai nghe Bluetooth', 0);

SELECT *
FROM Products;

-- ============================================================
-- BƯỚC 3: Index và EXPLAIN
-- ============================================================
-- Kiểm tra kế hoạch truy vấn trước khi tạo index.
EXPLAIN
SELECT *
FROM Products
WHERE productCode = 'P001';

EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop Dell Inspiron'
  AND productPrice = 18500000;

-- Tạo Unique Index: productCode không được trùng lặp.
CREATE UNIQUE INDEX ux_products_product_code
ON Products(productCode);

-- Tạo Composite Index theo thứ tự productName, productPrice.
CREATE INDEX ix_products_name_price
ON Products(productName, productPrice);

-- Kiểm tra lại kế hoạch truy vấn sau khi tạo index.
EXPLAIN
SELECT *
FROM Products
WHERE productCode = 'P001';

EXPLAIN
SELECT *
FROM Products
WHERE productName = 'Laptop Dell Inspiron'
  AND productPrice = 18500000;

SHOW INDEX FROM Products;

-- ============================================================
-- BƯỚC 4: View
-- ============================================================
DROP VIEW IF EXISTS product_views;

-- Tạo view lấy bốn thông tin sản phẩm.
CREATE VIEW product_views AS
SELECT
    productCode,
    productName,
    productPrice,
    productStatus
FROM Products;

-- Truy vấn dữ liệu từ view.
SELECT *
FROM product_views;

-- Sửa đổi view bằng cách bổ sung productAmount.
CREATE OR REPLACE VIEW product_views AS
SELECT
    productCode,
    productName,
    productPrice,
    productAmount,
    productStatus
FROM Products;

SELECT *
FROM product_views;

SHOW CREATE VIEW product_views;

-- Xóa view sau khi hoàn thành phần thực hành.
DROP VIEW IF EXISTS product_views;

-- ============================================================
-- BƯỚC 5: Stored Procedure CRUD
-- ============================================================
DROP PROCEDURE IF EXISTS getAllProducts;
DROP PROCEDURE IF EXISTS addProduct;
DROP PROCEDURE IF EXISTS updateProduct;
DROP PROCEDURE IF EXISTS deleteProduct;

DELIMITER //

-- 5.1. Lấy tất cả thông tin sản phẩm
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT
        Id,
        productCode,
        productName,
        productPrice,
        productAmount,
        productDescription,
        productStatus
    FROM Products
    ORDER BY Id;
END //

-- 5.2. Thêm một sản phẩm mới
CREATE PROCEDURE addProduct(
    IN p_productCode VARCHAR(20),
    IN p_productName VARCHAR(100),
    IN p_productPrice DECIMAL(12, 2),
    IN p_productAmount INT,
    IN p_productDescription VARCHAR(255),
    IN p_productStatus BIT
)
BEGIN
    INSERT INTO Products (
        productCode,
        productName,
        productPrice,
        productAmount,
        productDescription,
        productStatus
    )
    VALUES (
        p_productCode,
        p_productName,
        p_productPrice,
        p_productAmount,
        p_productDescription,
        p_productStatus
    );
END //

-- 5.3. Sửa thông tin sản phẩm theo Id
CREATE PROCEDURE updateProduct(
    IN p_id INT,
    IN p_productCode VARCHAR(20),
    IN p_productName VARCHAR(100),
    IN p_productPrice DECIMAL(12, 2),
    IN p_productAmount INT,
    IN p_productDescription VARCHAR(255),
    IN p_productStatus BIT
)
BEGIN
    UPDATE Products
    SET
        productCode = p_productCode,
        productName = p_productName,
        productPrice = p_productPrice,
        productAmount = p_productAmount,
        productDescription = p_productDescription,
        productStatus = p_productStatus
    WHERE Id = p_id;
END //

-- 5.4. Xóa sản phẩm theo Id
CREATE PROCEDURE deleteProduct(IN p_id INT)
BEGIN
    DELETE FROM Products
    WHERE Id = p_id;
END //

DELIMITER ;

-- ============================================================
-- Kiểm tra các procedure đã tạo
-- ============================================================
CALL getAllProducts();
SHOW PROCEDURE STATUS
WHERE Db = DATABASE();

-- Ví dụ gọi thêm/sửa/xóa. Bỏ chú thích khi muốn chạy thử:
-- CALL addProduct('P007', 'Webcam Logitech C270', 850000, 12, 'Webcam học trực tuyến', 1);
-- CALL updateProduct(1, 'P001', 'Laptop Dell Inspiron 15', 18900000, 12, 'Laptop văn phòng nâng cấp', 1);
-- CALL deleteProduct(7);
