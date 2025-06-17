package com.dao;

import com.model.Book;
import com.model.Book.Availability;
import java.sql.*;
import java.util.ArrayList;
import static java.util.Collections.list;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 *
 * @author Saidatul
 */

public class BookDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/borrowing_book_system?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "admin";

    private static final String INSERT_BOOK = "INSERT INTO book (title, author, publisher, ISBN, genre, year_of_publication, quantity, book_description, book_cover_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ALL_BOOKS = "SELECT * FROM book";    //select partial detail
    private static final String SELECT_ALL_BOOKS_DETAILS = "SELECT * FROM book";
    private static final String SELECT_BOOK_BY_ID = "SELECT * FROM book WHERE book_id = ?";
    private static final String SELECT_BOOK_ID_TITLE = "SELECT book_id, title, author FROM book";
    private static final String SELECT_BOOK_AVAILABILITY = "SELECT availability FROM book WHERE book_id = ?";
    private static final String SEARCH_BOOKS = "SELECT * FROM book WHERE title LIKE ? OR author LIKE ?"; 
    private static final String SELECT_TOTAL_BOOKS = "SELECT COUNT(*) FROM book";
    private static final String UPDATE_BOOK_AVAILABILITY = "UPDATE book SET availability = ? WHERE book_id = ?";
    private static final String DELETE_BOOK = "DELETE FROM book WHERE book_id = ?"; 
    
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found.");
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public boolean addBook(Book book) {
        String sql = INSERT_BOOK;
        boolean allInserted = true;

        try (Connection connection = getConnection()) {
            for (int i = 0; i < book.getQuantity(); i++) {
                try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                    stmt.setString(1, book.getTitle());
                    stmt.setString(2, book.getAuthor());
                    stmt.setString(3, book.getPublisher());
                    stmt.setString(4, book.getIsbn());
                    stmt.setString(5, book.getGenre());
                    stmt.setInt(6, book.getYearOfPublication());
                    stmt.setInt(7, 1); // Each row represents one book copy
                    stmt.setString(8, book.getBookDescription());
                    stmt.setString(9, book.getBookCoverImage());

                    if (stmt.executeUpdate() <= 0) {
                        allInserted = false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return allInserted;
    }
    
    public List<Book> getBooks(String keyword) {       //list for book catalog
        List<Book> bookList = new ArrayList<>();       //search book by keyword
        try {
            try (Connection conn = getConnection();
                PreparedStatement stmt = prepareStatement(conn, keyword);
                ResultSet rs = stmt.executeQuery()) {

                    while (rs.next()) {
                        Book b = new Book();
                        b.setBookId(rs.getInt("book_id"));
                        b.setTitle(rs.getString("title"));
                        b.setAuthor(rs.getString("author"));
                        b.setBookCoverImage(rs.getString("book_cover_image"));
                        bookList.add(b);
                    }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookList;
    }

    private PreparedStatement prepareStatement(Connection conn, String keyword) throws SQLException {
        if (keyword != null && !keyword.trim().isEmpty()) {
            PreparedStatement stmt = conn.prepareStatement(SEARCH_BOOKS);
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            return stmt;
        } else {
            return conn.prepareStatement(SELECT_ALL_BOOKS);
        }
    }
    
    public Book getBookById(int id) {
        Book book = null;
        String sql = SELECT_BOOK_BY_ID;
        try {
            try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        book = new Book();
                        book.setBookId(rs.getInt("book_id"));
                        book.setTitle(rs.getString("title"));
                        book.setAuthor(rs.getString("author"));
                        book.setBookDescription(rs.getString("book_description"));
                        book.setPublisher(rs.getString("publisher"));
                        book.setYearOfPublication(rs.getInt("year_of_publication"));
                        book.setBookCoverImage(rs.getString("book_cover_image"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return book;
    }
    
    public List<Book> getAllBooks() {    //for dropdown form borrowing book
        List<Book> books = new ArrayList<>();
        String sql = SELECT_BOOK_ID_TITLE;

        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setTitle(rs.getString("title"));
                books.add(book);
            }
        } catch (SQLException e) {
          e.printStackTrace();
        }
        return books;
    }
     
    
    public List<Book> getAllBooksDetailed() throws Exception {
        List<Book> bookList = new ArrayList<>();
        String sql = SELECT_ALL_BOOKS_DETAILS;

        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPublisher(rs.getString("publisher"));
                book.setIsbn(rs.getString("ISBN"));
                book.setGenre(rs.getString("genre"));
                book.setYearOfPublication(rs.getInt("year_of_publication"));
                book.setQuantity(rs.getInt("quantity"));
                book.setBookDescription(rs.getString("book_description"));
                book.setBookCoverImage(rs.getString("book_cover_image"));
                book.setAvailability(Availability.valueOf(rs.getString("availability").toUpperCase()));
                bookList.add(book);  
            }
        }
        return bookList;
    }
    
    public int getTotalBooks() throws SQLException {
        String sql = SELECT_TOTAL_BOOKS;
        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
        }
        return 0;
    }

    public String getAvailabilityById(int bookId) {
        String availability = "available";     // default
        String sql =  SELECT_BOOK_AVAILABILITY ;
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, bookId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    availability = rs.getString("availability");
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return availability;
    }
    
    public void updateBookAvailability(int bookId, String status) {
        String sql = UPDATE_BOOK_AVAILABILITY;
        try (Connection conn = getConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, status); 
                ps.setInt(2, bookId);
                ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean deleteBook(int bookId) {
        String sql = DELETE_BOOK;
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    


}
