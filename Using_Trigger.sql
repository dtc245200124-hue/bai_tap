-- [Thực hành] Trigger trong MySQL
-- Mục tiêu: tự động cập nhật phòng ban theo mức lương khi INSERT nhân viên

-- ============================================================
-- 1. Tạo CSDL và bảng employees
-- ============================================================
CREATE DATABASE IF NOT EXISTS company;
USE company;

CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

-- ============================================================
-- 2. Tạo BEFORE INSERT Trigger
-- ============================================================
-- Xóa trigger cũ để có thể chạy lại toàn bộ tệp nhiều lần.
DROP TRIGGER IF EXISTS update_department;

DELIMITER //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- ============================================================
-- 3. Demo sử dụng Trigger
-- ============================================================
-- Giá trị department ban đầu là 'A', nhưng trigger sẽ thay thế
-- bằng phòng ban tương ứng với salary trước khi INSERT.
INSERT INTO employees (name, department, salary)
VALUES
    ('John Doe', 'A', 3500),
    ('Jane Smith', 'A', 2000),
    ('David Johnson', 'A', 6000);

-- Kết quả mong đợi:
-- John Doe       -> Sales
-- Jane Smith     -> Support
-- David Johnson  -> Management
SELECT *
FROM employees
ORDER BY id;

-- Kiểm tra thông tin trigger
SHOW CREATE TRIGGER update_department;

-- Xem các trigger trong CSDL hiện tại
SHOW TRIGGERS;

-- Khi không còn sử dụng, có thể xóa trigger:
-- DROP TRIGGER IF EXISTS update_department;
