-- =====================================================
-- KENYA NATIONAL LIBRARY SERVICE - DATABASE MANAGEMENT SYSTEM
-- =====================================================
-- PLP Final Project - Database Systems
-- Assignment: Build a Complete Database Management System
-- Student: Philip Ondieki
-- Use Case: Library Management System
-- =====================================================

-- Create the database
CREATE DATABASE KenyaNationalLibrarySystem;
USE KenyaNationalLibrarySystem;

-- =====================================================
-- TABLE 1: AUTHORS
-- =====================================================
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE 2: CATEGORIES
-- =====================================================
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE 3: PUBLISHERS
-- =====================================================
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL UNIQUE,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    established_year YEAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE 4: BOOKS
-- =====================================================
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    publication_date DATE,
    pages INT,
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    location_shelf VARCHAR(20),
    publisher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL,
    
    -- Check Constraints
    CHECK (total_copies >= 0),
    CHECK (available_copies >= 0),
    CHECK (available_copies <= total_copies),
    CHECK (pages > 0)
);

-- =====================================================
-- TABLE 5: BOOK_AUTHORS (Many-to-Many Relationship)
-- =====================================================
CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Composite Primary Key
    PRIMARY KEY (book_id, author_id),
    
    -- Foreign Key Constraints
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 6: BOOK_CATEGORIES (Many-to-Many Relationship)
-- =====================================================
CREATE TABLE Book_Categories (
    book_id INT,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Composite Primary Key
    PRIMARY KEY (book_id, category_id),
    
    -- Foreign Key Constraints
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 7: MEMBERS
-- =====================================================
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    membership_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    membership_date DATE NOT NULL DEFAULT (CURDATE()),
    membership_type ENUM('Student', 'Faculty', 'Public', 'Senior') NOT NULL DEFAULT 'Public',
    membership_status ENUM('Active', 'Suspended', 'Expired') NOT NULL DEFAULT 'Active',
    max_books_allowed INT NOT NULL DEFAULT 5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Check Constraints
    CHECK (max_books_allowed > 0)
);

-- =====================================================
-- TABLE 8: MEMBER_DETAILS (One-to-One Relationship)
-- =====================================================
CREATE TABLE Member_Details (
    member_id INT PRIMARY KEY,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    occupation VARCHAR(100),
    institution VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraint (One-to-One)
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- =====================================================
-- TABLE 9: LOANS
-- =====================================================
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURDATE()),
    due_date DATE NOT NULL,
    return_date DATE,
    loan_status ENUM('Active', 'Returned', 'Overdue', 'Lost') NOT NULL DEFAULT 'Active',
    fine_amount DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE RESTRICT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE RESTRICT,
    
    -- Check Constraints
    CHECK (due_date >= loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date),
    CHECK (fine_amount >= 0)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert Categories
INSERT INTO Categories (category_name, description) VALUES
('Kenyan Literature', 'Literature by Kenyan authors'),
('African Literature', 'Literature from African authors'),
('History', 'Historical accounts and studies'),
('Science', 'Scientific and technical subjects'),
('Children', 'Books for young readers');

-- Insert Publishers
INSERT INTO Publishers (publisher_name, address, phone, established_year) VALUES
('East African Educational Publishers', 'Westlands, Nairobi', '+254-20-3748130', 1965),
('Longhorn Publishers', 'Industrial Area, Nairobi', '+254-20-6537234', 1965),
('Heinemann Kenya', 'Nairobi', '+254-20-2318134', 1962);

-- Insert Authors
INSERT INTO Authors (first_name, last_name, birth_date, nationality, email) VALUES
('Ngugi', 'wa Thiong\'o', '1938-01-05', 'Kenyan', 'ngugi@email.com'),
('Grace', 'Ogot', '1930-05-15', 'Kenyan', 'grace.ogot@email.com'),
('Meja', 'Mwangi', '1948-12-27', 'Kenyan', 'meja.mwangi@email.com'),
('Chinua', 'Achebe', '1930-11-16', 'Nigerian', 'chinua.achebe@email.com'),
('Margaret', 'Ogola', '1958-06-12', 'Kenyan', 'margaret.ogola@email.com');

-- Insert Books
INSERT INTO Books (isbn, title, publication_date, pages, total_copies, available_copies, publisher_id) VALUES
('9966251537', 'Weep Not, Child', '1964-01-01', 154, 5, 3, 3),
('9966251545', 'The River and the Source', '1994-01-01', 318, 8, 6, 1),
('9966251553', 'Going Down River Road', '1976-01-01', 180, 4, 2, 3),
('9780385474542', 'Things Fall Apart', '1958-01-01', 209, 10, 8, 2),
('9966251561', 'Land Without Thunder', '1968-01-01', 128, 3, 3, 1);

-- Insert Book-Author relationships (Many-to-Many)
INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1), -- Weep Not, Child by Ngugi wa Thiong'o
(2, 5), -- The River and the Source by Margaret Ogola
(3, 3), -- Going Down River Road by Meja Mwangi
(4, 4), -- Things Fall Apart by Chinua Achebe
(5, 2); -- Land Without Thunder by Grace Ogot

-- Insert Book-Category relationships (Many-to-Many)
INSERT INTO Book_Categories (book_id, category_id) VALUES
(1, 1), -- Weep Not, Child: Kenyan Literature
(2, 1), -- The River and the Source: Kenyan Literature
(3, 1), -- Going Down River Road: Kenyan Literature
(4, 2), -- Things Fall Apart: African Literature
(5, 1); -- Land Without Thunder: Kenyan Literature

-- Insert Members
INSERT INTO Members (membership_number, first_name, last_name, email, phone, membership_type, max_books_allowed) VALUES
('MEM001', 'Sarah', 'Wanjiku', 'sarah.wanjiku@gmail.com', '+254-722-234567', 'Public', 5),
('MEM002', 'James', 'Omondi', 'james.omondi@gmail.com', '+254-700-876543', 'Student', 8),
('MEM003', 'Ruth', 'Chepkemei', 'ruth.chepkemei@gmail.com', '+254-711-678901', 'Faculty', 15),
('MEM004', 'Peter', 'Muthomi', 'peter.muthomi@gmail.com', '+254-733-456789', 'Public', 5),
('MEM005', 'Grace', 'Awuor', 'grace.awuor@gmail.com', '+254-722-890123', 'Senior', 7);

-- Insert Member Details (One-to-One relationship)
INSERT INTO Member_Details (member_id, emergency_contact_name, emergency_contact_phone, occupation) VALUES
(1, 'John Wanjiku', '+254-722-111222', 'Teacher'),
(2, 'Mary Omondi', '+254-700-222333', 'Student'),
(3, 'David Chepkemei', '+254-711-333444', 'Professor'),
(4, 'Jane Muthomi', '+254-733-444555', 'Farmer'),
(5, 'Michael Awuor', '+254-722-555666', 'Retired');

-- Insert Sample Loans
INSERT INTO Loans (member_id, book_id, loan_date, due_date, return_date, loan_status, fine_amount) VALUES
(1, 1, '2024-08-15', '2024-09-14', '2024-09-10', 'Returned', 0.00),
(2, 4, '2024-08-20', '2024-09-19', NULL, 'Active', 0.00),
(3, 2, '2024-08-25', '2024-09-24', NULL, 'Active', 0.00),
(4, 5, '2024-07-10', '2024-08-09', '2024-08-15', 'Returned', 30.00),
(5, 3, '2024-08-30', '2024-09-29', NULL, 'Active', 0.00);

