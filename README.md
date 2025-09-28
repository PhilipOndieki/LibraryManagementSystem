# Kenya National Library Service - Database Management System

## Overview
A comprehensive relational database system designed for Kenya National Library Service, implementing a complete library management solution with proper database design principles.

## Project Details
- **Course**: Programming and Logic Paradigms (PLP)
- **Assignment**: Database Management System Final Project
- **Use Case**: Library Management System
- **Database**: MySQL
- **Context**: Kenya National Library Service

## Database Schema

### Tables Structure
The database consists of 9 interconnected tables:

1. **Authors** - Author information and details
2. **Categories** - Book categorization system
3. **Publishers** - Publisher information
4. **Books** - Book inventory and details
5. **Book_Authors** - Many-to-many relationship between books and authors
6. **Book_Categories** - Many-to-many relationship between books and categories
7. **Members** - Library member information
8. **Member_Details** - Extended member information (one-to-one)
9. **Loans** - Book lending records

### Relationships Implemented
- **One-to-One**: Members ↔ Member_Details
- **One-to-Many**: Publishers → Books, Members → Loans
- **Many-to-Many**: Books ↔ Authors, Books ↔ Categories

### Constraints Applied
- **PRIMARY KEY**: Unique identifiers for all tables
- **FOREIGN KEY**: Referential integrity across related tables
- **NOT NULL**: Required fields validation
- **UNIQUE**: Email addresses, ISBN numbers, membership numbers
- **CHECK**: Data validation for logical constraints

## Sample Data
The database includes realistic Kenyan context data:
- **Kenyan Authors**: Ngugi wa Thiong'o, Grace Ogot, Meja Mwangi, Margaret Ogola
- **African Literature**: Chinua Achebe classics
- **Local Publishers**: East African Educational Publishers, Longhorn Publishers, Heinemann Kenya
- **Kenyan Members**: Names and contact information with proper +254 phone format

## Installation Instructions

### Prerequisites
- MySQL Server 8.0 or higher
- MySQL client or workbench

### Setup Steps
1. Clone or download the project files
2. Open MySQL command line or workbench
3. Execute the SQL script:
```sql
source KenyaNationalLibrarySystem.sql
```

### Verification
After installation, verify the setup:
```sql
USE KenyaNationalLibrarySystem;
SHOW TABLES;
SELECT COUNT(*) FROM Books;
```

## Database Features

### Core Functionality
- Member registration and management
- Book inventory tracking
- Loan processing and tracking
- Category-based book organization
- Author and publisher information management

### Business Rules
- Members have borrowing limits based on membership type
- Books must be available for lending
- Loan dates and return dates are validated
- Fine calculations for overdue books
- Referential integrity maintained across all relationships

### Data Integrity
- Foreign key constraints prevent orphaned records
- Check constraints ensure logical data values
- Unique constraints prevent duplicate entries
- Cascading deletes where appropriate

## Technical Specifications
- **Database Engine**: MySQL
- **Character Set**: UTF-8
- **Storage Engine**: InnoDB (default)
- **Timestamp Tracking**: Created/updated timestamps on relevant tables

## File Structure
```
project/
│
├── KenyaNationalLibrarySystem.sql    # Main database schema and data
└── README.md                         # This documentation
```

## Usage Examples

### Query Available Books
```sql
SELECT title, available_copies FROM Books WHERE available_copies > 0;
```

### Find Books by Kenyan Authors
```sql
SELECT b.title, CONCAT(a.first_name, ' ', a.last_name) as author
FROM Books b
JOIN Book_Authors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
WHERE a.nationality = 'Kenyan';
```

### Check Active Loans
```sql
SELECT m.first_name, m.last_name, b.title, l.due_date
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.loan_status = 'Active';
```

## Assignment Compliance
This project fully meets the PLP Database Management System assignment requirements:
- ✅ Real-world use case implementation
- ✅ Well-structured relational database schema
- ✅ All required constraint types (PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE)
- ✅ All relationship types (One-to-One, One-to-Many, Many-to-Many)
- ✅ Single .sql file with CREATE DATABASE and CREATE TABLE statements
- ✅ Proper relationship constraints implementation

## License
This project is created for educational purposes as part of the PLP coursework.

---
**Created by**: Philip Ondieki
**Institution**: Programming and Logic Paradigms Program  
**Date**: September 2025