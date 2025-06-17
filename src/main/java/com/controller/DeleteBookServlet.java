package com.controller;

import com.dao.BookDAO;
import com.model.Book;
import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
/**
 *
 * @author Saidatul
 */
public class DeleteBookServlet extends HttpServlet {
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
                    String imageName = book.getBookCoverImage();

                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";  // Construct path to /uploads folder
                    File imageFile = new File(uploadPath + File.separator + imageName);
   
                    if (imageFile.exists() && !imageName.equals("default.png")) {  // Delete the image if it exists and not a default image
                        imageFile.delete();
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ListBooksServlet");
    }
}
