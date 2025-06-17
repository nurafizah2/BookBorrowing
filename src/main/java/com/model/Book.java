package com.model;
/**
 *
 * @Saidatul 
 */
public class Book implements java.io.Serializable{

    public enum Availability {
        AVAILABLE, UNAVAILABLE;
    }
    
    private int bookId;
    private String title;
    private String author;
    private String publisher;
    private String isbn;
    private String genre;
    private int yearOfPublication;
    private int quantity;
    private String bookDescription;
    private String bookCoverImage;
    private Availability availability;

    public Book() {
    }
 
    public Book( String title, String author, String publisher, String isbn, String genre, int yearOfPublication, int quantity, String bookDescription, String bookCoverImage, Availability availability) {
        
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.isbn = isbn;
        this.genre = genre;
        this.yearOfPublication = yearOfPublication;
        this.quantity = quantity;
        this.bookDescription = bookDescription;
        this.bookCoverImage = bookCoverImage;
        this.availability = availability;
    }
    
    public int getBookId() {
        return bookId;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public String getPublisher() {
        return publisher;
    }

    public String getIsbn() {
        return isbn;
    }

    public String getGenre() {
        return genre;
    }

    public int getYearOfPublication() {
        return yearOfPublication;
    }

    public int getQuantity() {
        return quantity;
    }

    public String getBookDescription() {
        return bookDescription;
    }

    public String getBookCoverImage() {
        return bookCoverImage;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public void setYearOfPublication(int yearOfPublication) {
        this.yearOfPublication = yearOfPublication;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setBookDescription(String bookDescription) {
        this.bookDescription = bookDescription;
    }

    public void setBookCoverImage(String bookCoverImage) {
        this.bookCoverImage = bookCoverImage;
    } 

    public Availability getAvailability() {
        return availability;
    }

    public void setAvailability(Availability availability) {
        this.availability = availability;
    }  
}
