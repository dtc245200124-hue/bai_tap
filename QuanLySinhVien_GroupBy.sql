-- [Thực hành] Sử dụng các hàm thông dụng trong SQL
-- CSDL: QuanLySinhVien
-- Bảng sử dụng: Student(StudentId, StudentName, Address), Mark(StudentId, SubjectId, Mark)

USE QuanLySinhVien;

-- 1. Hiển thị số lượng sinh viên ở từng nơi
SELECT
    Address,
    COUNT(StudentId) AS `Số lượng học viên`
FROM Student
GROUP BY Address;

-- 2. Tính điểm trung bình các môn học của mỗi học viên
SELECT
    S.StudentId,
    S.StudentName,
    ROUND(AVG(M.Mark), 2) AS `Điểm trung bình`
FROM Student AS S
JOIN Mark AS M ON M.StudentId = S.StudentId
GROUP BY S.StudentId, S.StudentName;

-- 3. Hiển thị học viên có điểm trung bình các môn học lớn hơn 15
SELECT
    S.StudentId,
    S.StudentName,
    ROUND(AVG(M.Mark), 2) AS `Điểm trung bình`
FROM Student AS S
JOIN Mark AS M ON M.StudentId = S.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) > 15;

-- 4. Hiển thị thông tin các học viên có điểm trung bình lớn nhất.
-- Truy vấn này trả về tất cả học viên nếu có nhiều người đồng hạng.
SELECT
    S.StudentId,
    S.StudentName,
    ROUND(AVG(M.Mark), 2) AS `Điểm trung bình`
FROM Student AS S
JOIN Mark AS M ON M.StudentId = S.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) >= ALL (
    SELECT AVG(M2.Mark)
    FROM Mark AS M2
    GROUP BY M2.StudentId
);

-- Cách viết tương đương, dễ đọc hơn trên các phiên bản MySQL hiện đại:
-- WITH StudentAverages AS (
--     SELECT StudentId, AVG(Mark) AS AverageMark
--     FROM Mark
--     GROUP BY StudentId
-- )
-- SELECT
--     S.StudentId,
--     S.StudentName,
--     ROUND(SA.AverageMark, 2) AS `Điểm trung bình`
-- FROM Student AS S
-- JOIN StudentAverages AS SA ON SA.StudentId = S.StudentId
-- WHERE SA.AverageMark = (SELECT MAX(AverageMark) FROM StudentAverages);
