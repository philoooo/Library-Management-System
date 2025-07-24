SELECT *
FROM books;

SELECT *
FROM branch;

SELECT *
FROM employees;

SELECT *
FROM issued_status;

SELECT *
FROM return_status;


-- Project Tasks:

-- 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- 2. Update an Existing Member's Address
UPDATE members
SET member_address = '124 Main St'
WHERE member_id = 'C101';

-- 3. Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- 4. Select all books issued by the employee with emp_id = 'E101'.
SELECT * 
FROM issued_status
WHERE issued_emp_id = 'E101';

-- 5. Find members who have issued more than one book.
SELECT 
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;

-- CTAS
-- 6. Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_counts
AS
SELECT 
	b.isbn, b.book_title, COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;

SELECT * 
FROM book_counts;

-- 7. Retrieve all books in a specific category.
SELECT * 
FROM books
WHERE category = 'Classic';

-- 8. Find Total Rental Income by Category.
SELECT
	b.category,
	SUM(b.rental_price),
	COUNT(*)
FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;

-- 9. List Members Who Registered in the Last 500 Days.
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '500 days';

-- 10. List Employees with Their Branch Manager's Name and their branch details.
SELECT 
	e1.*,
	b.manager_id,
	e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
ON b.branch_id = e1.branch_id
JOIN employees AS e2
ON b.manager_id = e2.emp_id;

-- 11. Create a Table of Books with Rental Price Above a Certain Threshold of $7.50 USD.
CREATE TABLE expensive_books
AS
SELECT * 
FROM books
WHERE rental_price > 7.50;

-- 12. Retrieve the List of Books Not Yet Returned.
SELECT 
	DISTINCT isd.issued_book_name
FROM issued_status AS isd
LEFT JOIN return_status AS rs
ON isd.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;








