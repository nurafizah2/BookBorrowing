package com.controller;

import com.dao.BookDAO;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.Bucket;
import com.google.firebase.cloud.StorageClient;
import com.model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.util.logging.Logger;
import java.util.logging.Level;
/**
 *
 * @author Saidatul
 */
public class DeleteBookServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(DeleteBookServlet.class.getName());
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookIdStr = request.getParameter("bookId");

        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                BookDAO dao = new BookDAO();
                Book book = dao.getBookById(bookId);

                if (book != null) {
                    String imageUrl = book.getBookCoverImage();

                    // Extract Firebase path
                    if (imageUrl != null && imageUrl.contains("storage.googleapis.com")) {
                        String firebasePath = extractFirebasePath(imageUrl);

                        // Delete from Firebase
                        Bucket bucket = StorageClient.getInstance().bucket();
                        Blob blob = bucket.get(firebasePath);
                        if (blob != null) {
                            blob.delete();
                        }
                    }
               
                    boolean success = dao.deleteBook(bookId);  

                    if (success) {
                        request.getSession().setAttribute("successMessage", "Book deleted successfully!");
                    } else {
                        request.getSession().setAttribute("errorMessage", "Failed to delete book.");
                    }

                } else {
                    request.getSession().setAttribute("errorMessage", "Book not found.");
                }

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid book ID.");
            }
        }
        response.sendRedirect("ListBooksServlet");
    }
    
    private String extractFirebasePath(String url) {
        try {
            int index = url.indexOf("/covers/");
            if (index != -1) {
                return url.substring(index + 1); // remove the first '/' in path
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error extracting Firebase path from URL: " + url, e);
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ListBooksServlet");
    }
}
