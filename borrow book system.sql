CREATE DATABASE borrowing_book_system;

CREATE TABLE users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(255),
    role ENUM('admin', 'member') NOT NULL
);
  
CREATE TABLE book(
	book_id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(255) NOT NULL,
	author VARCHAR(255) NOT NULL,
	publisher VARCHAR(255) NOT NULL,
	ISBN VARCHAR(20) NOT NULL,
	genre VARCHAR(50) NOT NULL,
	year_of_publication INT NOT NULL,
	quantity INT NOT NULL,
	book_description TEXT NOT NULL,
	book_cover_image TEXT,
	availability ENUM('available', 'unavailable') NOT NULL DEFAULT 'available'
);

CREATE TABLE borrowing_approval (
  book_approval_id INT PRIMARY KEY AUTO_INCREMENT,
  book_id INT,
  borrow_date DATE NOT NULL,
  status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
  return_date DATE,
  user_id INT,
  actual_return_date DATE,
  FOREIGN KEY (book_id) REFERENCES book(book_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    book_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);
    
SELECT * FROM book;
SELECT * FROM users;
SELECT * FROM borrowing_approval;
SELECT * FROM book WHERE availability = 'unavailable';
SELECT * FROM borrowing_approval WHERE status = 'APPROVED';
SELECT COUNT(*)
FROM book;

