-- [Thực hành] Truyền tham số vào Stored Procedure trong MySQL
-- CSDL mẫu: classicmodels
-- Bảng sử dụng: customers

USE classicmodels;

-- ============================================================
-- 1. Tham số IN: tìm khách hàng theo customerNumber
-- ============================================================
DROP PROCEDURE IF EXISTS getCusById;

DELIMITER //

CREATE PROCEDURE getCusById(IN p_customerNumber INT)
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = p_customerNumber;
END //

DELIMITER ;

-- Gọi procedure với customerNumber = 175
CALL getCusById(175);

-- ============================================================
-- 2. Tham số OUT: đếm số khách hàng theo thành phố
-- ============================================================
DROP PROCEDURE IF EXISTS getCustomersCountByCity;

DELIMITER //

CREATE PROCEDURE getCustomersCountByCity(
    IN p_city VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO p_total
    FROM customers
    WHERE city = p_city;
END //

DELIMITER ;

-- Biến người dùng truyền vào OUT phải có tiền tố @.
CALL getCustomersCountByCity('Lyon', @total);
SELECT @total AS `Số lượng khách hàng tại Lyon`;

-- ============================================================
-- 3. Tham số INOUT: cộng thêm giá trị vào bộ đếm
-- ============================================================
DROP PROCEDURE IF EXISTS setCounter;

DELIMITER //

CREATE PROCEDURE setCounter(
    INOUT p_counter INT,
    IN p_increment INT
)
BEGIN
    SET p_counter = p_counter + p_increment;
END //

DELIMITER ;

-- Khởi tạo biến trước khi truyền vào INOUT.
SET @counter = 1;

CALL setCounter(@counter, 1); -- @counter = 2
CALL setCounter(@counter, 1); -- @counter = 3
CALL setCounter(@counter, 5); -- @counter = 8

SELECT @counter AS `Giá trị counter cuối cùng`;

-- ============================================================
-- 4. Xem danh sách procedure đã tạo
-- ============================================================
SHOW PROCEDURE STATUS
WHERE Db = DATABASE();

-- Khi không còn sử dụng, có thể xóa các procedure:
-- DROP PROCEDURE IF EXISTS getCusById;
-- DROP PROCEDURE IF EXISTS getCustomersCountByCity;
-- DROP PROCEDURE IF EXISTS setCounter;
