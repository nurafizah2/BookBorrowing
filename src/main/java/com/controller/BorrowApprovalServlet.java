package com.controller;

import com.dao.BookDAO;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.dao.BorrowDAO;
import com.model.BorrowApproval;
import java.time.LocalDate;
import java.util.List;
/**
 *
 * @author Nurafizah
 */
public class BorrowApprovalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BorrowDAO dao = new BorrowDAO();

        try {
            List<BorrowApproval> borrowApproval = dao.getAllPendingRequests();  
            request.setAttribute("borrowApproval", borrowApproval);
            RequestDispatcher dispatcher = request.getRequestDispatcher("borrowapproval.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("action");

        BorrowDAO borrowDAO = new BorrowDAO();
        BookDAO bookDAO = new BookDAO();

        try {
            if ("APPROVED".equals(action)) {
                LocalDate returnDate = LocalDate.now().plusDays(7);
                borrowDAO.updateStatus(requestId, "APPROVED", returnDate);
                bookDAO.updateBookAvailability(bookId, "unavailable");
                borrowDAO.sendNotification(userId, "Your borrow request has been approved.");
          


            } else if ("REJECTED".equals(action)) {
                borrowDAO.updateStatus(requestId, "REJECTED", null);
                borrowDAO.sendNotification(userId, "Your borrow request has been rejected.");
                borrowDAO.deleteRequest(requestId);
            }
            System.out.println("Action/status received: " + action);


        } catch (Exception e) {
            throw new ServletException(e);
        }
        response.sendRedirect("BorrowApprovalServlet");
    }
}