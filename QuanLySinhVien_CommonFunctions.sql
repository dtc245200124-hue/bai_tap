-- [Bài tập] Luyện tập các hàm thông dụng trong SQL
-- CSDL: QuanLySinhVien
-- Bảng sử dụng:
--   Subject(SubjectId, SubjectName, Credit)
--   Student(StudentId, StudentName, Address, ...)
--   Mark(StudentId, SubjectId, Mark)

USE QuanLySinhVien;

-- 1. Hiển thị tất cả thông tin môn học có Credit lớn nhất
SELECT *
FROM Subject
WHERE Credit = (SELECT MAX(Credit) FROM Subject);

-- 2. Hiển thị thông tin môn học có điểm thi lớn nhất.
-- Nếu nhiều môn cùng có điểm cao nhất, truy vấn trả về tất cả các môn đó.
SELECT
    S.SubjectId,
    S.SubjectName,
    S.Credit,
    M.Mark AS `Điểm thi`
FROM Subject AS S
JOIN Mark AS M ON M.SubjectId = S.SubjectId
WHERE M.Mark = (SELECT MAX(M2.Mark) FROM Mark AS M2);

-- 3. Hiển thị thông tin sinh viên và điểm trung bình,
--    xếp hạng theo thứ tự điểm giảm dần
SELECT
    S.StudentId,
    S.StudentName,
    ROUND(AVG(M.Mark), 2) AS `Điểm trung bình`
FROM Student AS S
JOIN Mark AS M ON M.StudentId = S.StudentId
GROUP BY S.StudentId, S.StudentName
ORDER BY AVG(M.Mark) DESC;

-- Cách viết bổ sung cho MySQL 8.0+, dùng RANK() để hiển thị thứ hạng.
-- Bỏ dấu chú thích nếu muốn xem cả cột thứ hạng:
-- SELECT
--     S.StudentId,
--     S.StudentName,
--     ROUND(AVG(M.Mark), 2) AS `Điểm trung bình`,
--     RANK() OVER (ORDER BY AVG(M.Mark) DESC) AS `Xếp hạng`
-- FROM Student AS S
-- JOIN Mark AS M ON M.StudentId = S.StudentId
-- GROUP BY S.StudentId, S.StudentName
-- ORDER BY `Điểm trung bình` DESC;
