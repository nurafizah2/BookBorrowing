package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.dao.BookDAO;
import java.io.IOException;

/**
 *
 * @author Nurafizah
 */

public class UpdateBookAvailabilityServlet extends HttpServlet {
    public UpdateBookAvailabilityServlet() {
            super();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        BookDAO dao = new BookDAO();
        String currentStatus = dao.getAvailabilityById(bookId); 

        String newStatus = currentStatus.equalsIgnoreCase("Available") ? "Unavailable" : "Available";
        dao.updateBookAvailability(bookId, newStatus);

        response.sendRedirect("ListBooksServlet");
    }
}

