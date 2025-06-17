package com.model;
import java.sql.Date;
/**
 *
 * @author Nurafizah
 */
public class BorrowApproval implements java.io.Serializable{
    
    public enum Status {
       PENDING, APPROVED, REJECTED
    }
    
    private int id;
    private int bookId;
    private String bookTitle;
    private String fullName;
    private String username;
    private String email;
    private Date borrowDate;
    private Date returnDate;
    private Status status;
    private int userId;
    private Date actualReturnDate;

    public BorrowApproval() {}

    public BorrowApproval(int id, int bookId, String bookTitle, String fullName,String username, String email, Date borrowDate, Date returnDate, Status status,  int userId, Date actualReturnDate) {
        this.id = id;
        this.bookId = bookId;
        this.bookTitle = bookTitle; 
        this.fullName = fullName;
        this.username = username;
        this.email = email;
        this.borrowDate = borrowDate;
        this.returnDate = returnDate;
        this.status = status;
        this.userId = userId;
        this.actualReturnDate = actualReturnDate;
    }
   
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public java.util.Date getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Date borrowDate) {
        this.borrowDate = borrowDate;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public java.util.Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }  
    
    public Date getActualReturnDate() {
    return actualReturnDate;
    }

    public void setActualReturnDate(Date actualReturnDate) {
        this.actualReturnDate = actualReturnDate;
    }
}
