package com.model;
import java.sql.Timestamp;
/**
 *
 * @author Nurafizah
 */
public class Notification implements java.io.Serializable {
    private int id;
    private int userId;
    private String message;
    private Timestamp timeStamp;
    private boolean isRead;
    private String bookTitle;
    private String author;
    private int bookId;

    public Notification() {
    }

    public Notification(int id, int userId, String message, Timestamp timeStamp, boolean isRead, String bookTitle, String author, int bookId) {
        this.id = id;
        this.userId = userId;
        this.message = message;
        this.timeStamp = timeStamp;
        this.isRead = isRead;
        this.bookTitle = bookTitle;
        this.author = author;
        this.bookId = bookId;
    }

    public Notification(int userId, String message, Timestamp timeStamp, boolean isRead, String bookTitle, String author, int bookId) {
        this.userId = userId;
        this.message = message;
        this.timeStamp = timeStamp;
        this.isRead = isRead;
        this.bookTitle = bookTitle;
        this.author = author;
        this.bookId = bookId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(Timestamp timeStamp) {
        this.timeStamp = timeStamp;
    }

    public boolean isIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }     
}
