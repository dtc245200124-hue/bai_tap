-- [Thực hành] Chỉ mục trong MySQL
-- CSDL mẫu: classicmodels
-- Mục tiêu: so sánh kế hoạch truy vấn trước và sau khi tạo INDEX

USE classicmodels;

-- ============================================================
-- 1. Kiểm tra kế hoạch truy vấn trước khi tạo chỉ mục
-- ============================================================
EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';

-- Có thể đo thời gian thực thi nếu phiên bản MySQL hỗ trợ:
-- SET PROFILING = 1;
-- SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';
-- SHOW PROFILES;

-- ============================================================
-- 2. Tạo chỉ mục cho customerName
-- ============================================================
ALTER TABLE customers
    ADD INDEX idx_customerName (customerName);

-- Kiểm tra lại kế hoạch truy vấn sau khi tạo chỉ mục.
-- Có thể quan sát possible_keys, key, key_len, rows và type.
EXPLAIN
SELECT *
FROM customers
WHERE customerName = 'Land of Toys Inc.';

-- ============================================================
-- 3. Tạo chỉ mục ghép cho contactFirstName và contactLastName
-- ============================================================
ALTER TABLE customers
    ADD INDEX idx_full_name (contactFirstName, contactLastName);

-- Kiểm tra truy vấn sử dụng cột đứng đầu của chỉ mục ghép.
EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
   OR contactFirstName = 'King';

-- Ví dụ sử dụng đầy đủ hai cột trong chỉ mục ghép:
EXPLAIN
SELECT *
FROM customers
WHERE contactFirstName = 'Jean'
  AND contactLastName = 'King';

-- Xem danh sách chỉ mục hiện có của bảng.
SHOW INDEX FROM customers;

-- ============================================================
-- 4. Xóa chỉ mục khi không còn sử dụng
-- ============================================================
ALTER TABLE customers
    DROP INDEX idx_full_name;

ALTER TABLE customers
    DROP INDEX idx_customerName;

-- Kiểm tra lại danh sách chỉ mục sau khi xóa.
SHOW INDEX FROM customers;

-- Ghi chú:
-- - type = ALL thường cho thấy MySQL phải quét toàn bộ bảng.
-- - type = ref/range thường hiệu quả hơn khi truy vấn dùng INDEX.
-- - possible_keys là các chỉ mục có khả năng được dùng.
-- - key là chỉ mục thực tế được MySQL chọn.
-- - rows là số dòng MySQL dự đoán cần đọc.
-- - Chỉ mục giúp đọc nhanh hơn nhưng làm tăng chi phí INSERT, UPDATE và DELETE.
