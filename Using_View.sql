-- [Thực hành] View trong MySQL
-- CSDL mẫu: classicmodels
-- Bảng sử dụng: customers

USE classicmodels;

-- ============================================================
-- 1. Tạo view customer_views
-- ============================================================
DROP VIEW IF EXISTS customer_views;

CREATE VIEW customer_views AS
SELECT
    customerNumber,
    customerName,
    phone
FROM customers;

-- Truy vấn dữ liệu từ view
SELECT *
FROM customer_views;

-- ============================================================
-- 2. Cập nhật view
-- ============================================================
-- View này lấy dữ liệu từ một bảng, không dùng GROUP BY,
-- HAVING, ORDER BY, UNION, DISTINCT hay hàm tổng hợp nên
-- vẫn có thể cập nhật trong các điều kiện phù hợp.
CREATE OR REPLACE VIEW customer_views AS
SELECT
    customerNumber,
    customerName,
    contactFirstName,
    contactLastName,
    phone
FROM customers
WHERE city = 'Nantes';

-- Kiểm tra view sau khi cập nhật
SELECT *
FROM customer_views;

-- Xem câu lệnh định nghĩa view
SHOW CREATE VIEW customer_views;

-- Có thể cập nhật cột cơ sở thông qua view nếu thỏa mãn điều kiện
-- UPDATE customer_views
-- SET phone = '01 23 45 67 89'
-- WHERE customerNumber = 103;

-- ============================================================
-- 3. Xóa view
-- ============================================================
DROP VIEW IF EXISTS customer_views;

-- Kiểm tra danh sách view còn lại trong database
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
