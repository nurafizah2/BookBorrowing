package com.controller;

import com.dao.BorrowDAO;
import com.model.BorrowApproval;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;
/**
 *
 * @author Nurafizah
 */

public class ReturnBookServlet extends HttpServlet {
     private static final Logger logger = Logger.getLogger(ReturnBookServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int borrowId = Integer.parseInt(request.getParameter("borrowId"));

        try {
            BorrowDAO dao = new BorrowDAO();
            boolean success = dao.markBookAsReturned(borrowId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Book marked as returned.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to return book.");
            }

              response.sendRedirect("ApprovedBorrowedBookServlet");

        } catch (IOException e) {
            e.printStackTrace(response.getWriter());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            BorrowDAO dao = new BorrowDAO();
            List<BorrowApproval> returnedList = dao.getReturnedBooks();
            
            request.setAttribute("returnedList", returnedList);
            request.getRequestDispatcher("returned_book.jsp").forward(request, response);
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error loading returned books", ex);
            request.setAttribute("errorMessage", "Error loading returned books.");
            request.getRequestDispatcher("error.jsp").forward(request, response); // optional error page
        }
}

}
