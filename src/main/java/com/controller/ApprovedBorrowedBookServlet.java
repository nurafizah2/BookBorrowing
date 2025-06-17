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
/**
 *
 * @author Nurafizah
 */
public class ApprovedBorrowedBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        BorrowDAO borrowDAO = new BorrowDAO();
        try {
            List<BorrowApproval> approvedList = borrowDAO.getApprovedBorrowRequests();
            request.setAttribute("approvedList", approvedList);
            request.getRequestDispatcher("approved_borrow_books.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
