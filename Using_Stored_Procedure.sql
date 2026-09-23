-- [Thực hành] Stored Procedure trong MySQL
-- CSDL mẫu: classicmodels
-- Bảng sử dụng: customers

USE classicmodels;

-- ============================================================
-- 1. Tạo Stored Procedure lấy toàn bộ khách hàng
-- ============================================================
DROP PROCEDURE IF EXISTS findAllCustomers;

DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers;
END //

DELIMITER ;

-- Gọi procedure
CALL findAllCustomers();

-- ============================================================
-- 2. Stored Procedure có tham số tìm khách hàng theo mã
-- ============================================================
DROP PROCEDURE IF EXISTS findCustomerByNumber;

DELIMITER //

CREATE PROCEDURE findCustomerByNumber(IN p_customerNumber INT)
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = p_customerNumber;
END //

DELIMITER ;

-- Tìm khách hàng có customerNumber = 175
CALL findCustomerByNumber(175);

-- ============================================================
-- 3. Stored Procedure có tham số tìm theo tên khách hàng
-- ============================================================
DROP PROCEDURE IF EXISTS findCustomersByName;

DELIMITER //

CREATE PROCEDURE findCustomersByName(IN p_customerName VARCHAR(50))
BEGIN
    SELECT *
    FROM customers
    WHERE customerName LIKE CONCAT('%', p_customerName, '%');
END //

DELIMITER ;

-- Ví dụ: tìm các khách hàng có tên chứa "Gift"
CALL findCustomersByName('Gift');

-- ============================================================
-- 4. Cách sửa procedure trong MySQL
-- ============================================================
-- MySQL không có ALTER PROCEDURE để thay đổi phần thân procedure.
-- Cách thông dụng là xóa procedure cũ rồi tạo lại.
DROP PROCEDURE IF EXISTS findAllCustomers;

DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = 175;
END //

DELIMITER ;

-- Kiểm tra procedure sau khi tạo lại
CALL findAllCustomers();

-- Xem danh sách procedure trong database hiện tại
SHOW PROCEDURE STATUS
WHERE Db = DATABASE();

-- Khi không còn sử dụng, có thể xóa các procedure:
-- DROP PROCEDURE IF EXISTS findAllCustomers;
-- DROP PROCEDURE IF EXISTS findCustomerByNumber;
-- DROP PROCEDURE IF EXISTS findCustomersByName;
