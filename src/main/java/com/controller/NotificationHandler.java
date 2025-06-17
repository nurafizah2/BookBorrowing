package com.controller;

import com.dao.BorrowDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nurafizah
 */

public class NotificationHandler extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int notificationId = Integer.parseInt(request.getParameter("id"));
        BorrowDAO dao = new BorrowDAO();

        try {
            dao.markNotificationAsRead(notificationId);
        } catch (Exception e) {
        }
        response.sendRedirect("UserHomeServlet");  
    }
}
