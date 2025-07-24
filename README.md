# Library Management System Using SQL

## Project Overview

**Project Title**: Library Management System  
**Database**: `Library_Project_2`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.


![Library_project](https://github.com/philoooo/Library-Management-System/blob/main/ERD_Library%20.png)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.

## Project Structure

### 1. Database Setup

![ERD](https://github.com/philoooo/Library-Management-System/blob/main/ERD_Library%20.png)

- **Database Creation**: Created a database named `Library_Project_2`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
	(
		branch_id VARCHAR(10) PRIMARY KEY,
		manager_id VARCHAR(10),
		branch_address VARCHAR(60),
		contact_no VARCHAR(10)
	);

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(25);


DROP TABLE IF EXISTS employees;
CREATE TABLE employees
	(
		emp_id VARCHAR(10) PRIMARY KEY,
		emp_name VARCHAR(25),
		position VARCHAR(25),
		salary FLOAT,
		branch_id VARCHAR(25) -- FK
	);

DROP TABLE IF EXISTS books;
CREATE TABLE books
	(
		isbn VARCHAR(20) PRIMARY KEY,
		book_title VARCHAR(75),
		category VARCHAR(25),
		rental_price FLOAT,
		status VARCHAR(15),
		author VARCHAR(55),
		publisher VARCHAR(55)
	);
	
DROP TABLE IF EXISTS members;
CREATE TABLE members
	(
	member_id VARCHAR(20) PRIMARY KEY,
	member_name VARCHAR(35),
	member_address VARCHAR(75),
	reg_date DATE
	);


DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
	(
		issued_id VARCHAR(15) PRIMARY KEY,
		issued_member_id VARCHAR(15), -- FK
		issued_book_name VARCHAR(75),
		issued_date DATE,
		issued_book_isbn VARCHAR(25), -- FK
		issued_emp_id VARCHAR(10) -- FK
	);



DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
	(
		return_id VARCHAR(10) PRIMARY KEY,
		issued_id VARCHAR(10),
		return_book_name VARCHAR(75),
		return_date DATE,
		return_book_isbn VARCHAR(20)
	);

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);
```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

**2. Update an Existing Member's Address

```sql
UPDATE members
SET member_address = '124 Main St'
WHERE member_id = 'C101';
```

**3. Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

**4. Select all books issued by the employee with emp_id = 'E101'.

```sql
SELECT * 
FROM issued_status
WHERE issued_emp_id = 'E101';
```

**5. Find members who have issued more than one book.

```sql
SELECT 
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;
```

### CTAS (Create Table As Select)

**6. Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
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
```

### Data Analysis & Findings

The following SQL queries were used to address specific questions:

**7. Retrieve all books in a specific category.

```sql
SELECT * 
FROM books
WHERE category = 'Classic';
```

**8. Find Total Rental Income by Category.

```sql
SELECT
	b.category,
	SUM(b.rental_price),
	COUNT(*)
FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;
```

**9. List Members Who Registered in the Last 500 Days.

```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '500 days';
```

**10. List Employees with Their Branch Manager's Name and their branch details.

```sql
SELECT 
	e1.*,
	b.manager_id,
	e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
ON b.branch_id = e1.branch_id
JOIN employees AS e2
ON b.manager_id = e2.emp_id;
```

**11. Create a Table of Books with Rental Price Above a Certain Threshold of $7.50 USD.

```sql
CREATE TABLE expensive_books
AS
SELECT * 
FROM books
WHERE rental_price > 7.50;
```

**12. Retrieve the List of Books Not Yet Returned.

```sql
SELECT 
	DISTINCT isd.issued_book_name
FROM issued_status AS isd
LEFT JOIN return_status AS rs
ON isd.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.
