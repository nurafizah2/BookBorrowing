package com.controller;

import com.dao.BookDAO;
import com.google.cloud.storage.Acl;
import com.model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;
import com.google.firebase.cloud.StorageClient;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import java.io.InputStream;
/**
 *
 * @author Saidatul
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class AddBookProcessing extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String title = request.getParameter("title").trim();
        String author = request.getParameter("author").trim();
        String publisher = request.getParameter("publisher").trim();
        String isbn = request.getParameter("isbn").trim();
        String genre = request.getParameter("genre").trim();
        int year = Integer.parseInt(request.getParameter("year"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String description = request.getParameter("description").trim();

// Create Book object (BEFORE setting cover image)
Book newBook = new Book();
newBook.setTitle(title);
newBook.setAuthor(author);
newBook.setPublisher(publisher);
newBook.setIsbn(isbn);
newBook.setGenre(genre);
newBook.setYearOfPublication(year);
newBook.setQuantity(quantity); 
newBook.setBookDescription(description);

// Handle cover image (file or URL)
Part filePart = request.getPart("cover_image_file");

if (filePart != null && filePart.getSize() > 0) {
    String fileName = UUID.randomUUID().toString();
    InputStream fileStream = filePart.getInputStream();

    Bucket bucket = StorageClient.getInstance().bucket();
    Blob blob = bucket.create("covers/" + fileName, fileStream, filePart.getContentType());
    blob.createAcl(Acl.of(Acl.User.ofAllUsers(), Acl.Role.READER));

    // Generate public URL
    String imageUrl = "https://storage.googleapis.com/" + bucket.getName() + "/" + blob.getName();

    // ✅ Set file upload URL to book
    newBook.setBookCoverImage(imageUrl);

} else {
    // ✅ If no file, try to use URL input instead
    String urlInput = request.getParameter("cover_image_url");
    if (urlInput != null && !urlInput.trim().isEmpty()) {
        newBook.setBookCoverImage(urlInput.trim());
    } else {
        newBook.setBookCoverImage(""); // Or set default image URL
    }
}



        try {
            BookDAO dao = new BookDAO();
            boolean inserted = dao.addBook(newBook);

            if (inserted) {
                request.getSession().setAttribute("successMessage", "Book added successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add book.");
            }

            response.sendRedirect("ListBooksServlet");

        } catch (IOException e) {
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("addbook.jsp");
    }
}


