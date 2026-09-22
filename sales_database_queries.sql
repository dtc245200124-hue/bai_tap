-- BÀI TẬP: THAO TÁC VỚI CSDL QUẢN LÝ BÁN HÀNG
-- MySQL
-- Lưu ý: Order là từ khóa đặc biệt nên luôn đặt trong dấu backtick.

CREATE DATABASE IF NOT EXISTS sales_management;
USE sales_management;

-- Xóa bảng theo thứ tự phụ thuộc khóa ngoại để có thể chạy lại script.
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    cAge TINYINT
);

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice INT NULL,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25) NOT NULL,
    pPrice INT NOT NULL
);

CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL,
    PRIMARY KEY (oID, pID),
    CONSTRAINT fk_detail_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),
    CONSTRAINT fk_detail_product
        FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- Dữ liệu Customer
INSERT INTO Customer (cID, Name, cAge) VALUES
    (1, 'Minh Quan', 10),
    (2, 'Ngoc Oanh', 20),
    (3, 'Hong Ha', 50);

-- Dữ liệu Order; oTotalPrice ban đầu được để NULL vì sẽ tính từ OrderDetail.
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
    (1, 1, '2006-03-21 00:00:00', NULL),
    (2, 2, '2006-03-23 00:00:00', NULL),
    (3, 1, '2006-03-16 00:00:00', NULL);

-- Dữ liệu Product
INSERT INTO Product (pID, pName, pPrice) VALUES
    (1, 'May Giat', 3),
    (2, 'Tu Lanh', 5),
    (3, 'Dieu Hoa', 7),
    (4, 'Quat', 1),
    (5, 'Bep Dien', 2);

-- Dữ liệu OrderDetail
INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
    (1, 1, 3),
    (1, 3, 7),
    (1, 4, 2),
    (2, 1, 1),
    (3, 1, 8),
    (2, 5, 4),
    (2, 3, 3);

-- 1. Hiển thị oID, oDate và giá trị lưu trong hóa đơn.
-- oTotalPrice đang NULL theo dữ liệu đề bài, nên hiển thị với bí danh oPrice.
SELECT
    oID,
    oDate,
    oTotalPrice AS oPrice
FROM `Order`
ORDER BY oID;

-- 2. Hiển thị khách hàng đã mua hàng và các sản phẩm họ đã mua.
-- DISTINCT tránh lặp lại cùng một cặp khách hàng - sản phẩm.
SELECT DISTINCT
    c.cID,
    c.Name AS CustomerName,
    p.pID,
    p.pName AS ProductName
FROM Customer AS c
JOIN `Order` AS o
    ON o.cID = c.cID
JOIN OrderDetail AS od
    ON od.oID = o.oID
JOIN Product AS p
    ON p.pID = od.pID
ORDER BY c.cID, p.pID;

-- 3. Hiển thị khách hàng chưa từng mua bất kỳ sản phẩm nào.
SELECT
    c.cID,
    c.Name,
    c.cAge
FROM Customer AS c
LEFT JOIN `Order` AS o
    ON o.cID = c.cID
WHERE o.oID IS NULL
ORDER BY c.cID;

-- 4. Tính giá tiền thực tế của từng hóa đơn.
-- Giá mỗi dòng = odQTY * pPrice; tổng hóa đơn = SUM các dòng.
SELECT
    o.oID,
    o.oDate,
    SUM(od.odQTY * p.pPrice) AS oPrice
FROM `Order` AS o
JOIN OrderDetail AS od
    ON od.oID = o.oID
JOIN Product AS p
    ON p.pID = od.pID
GROUP BY o.oID, o.oDate
ORDER BY o.oID;

-- Kết quả kỳ vọng cho truy vấn 4:
-- Hóa đơn 1: (3*3) + (7*7) + (2*1) = 60
-- Hóa đơn 2: (1*3) + (4*2) + (3*7) = 32
-- Hóa đơn 3: 8*3 = 24
