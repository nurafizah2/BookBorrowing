package com.controller;

import com.dao.BookDAO;
import com.dao.BorrowDAO;
import com.dao.UserDAO;
import com.model.BorrowApproval;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Nurafizah
 */
public class AdminHome extends HttpServlet {
  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            BookDAO bookDAO = new BookDAO();
            UserDAO userDAO = new UserDAO();
            BorrowDAO borrowDAO = new BorrowDAO();
            
            int totalBooks = bookDAO.getTotalBooks();
            int totalUsers = userDAO.getTotalUsers();
            int pendingRequests = borrowDAO.getPendingRequestsCount();
            int borrowedBooks = borrowDAO.getBorrowedBooks();
            List<BorrowApproval> recentRequests = borrowDAO.getRecentBorrowRequests();
            
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("borrowedBooks", borrowedBooks);
            request.setAttribute("recentRequests", recentRequests);
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(AdminHome.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

