package com.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.dao.UserDAO;
/**
 *
 * @author Nurafizah
 */
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));

            UserDAO dao = new UserDAO();
            dao.deleteUser(userId);

            response.sendRedirect("ListOfUserServlet"); 
        } catch (IOException | NumberFormatException e) {
            response.getWriter().write("Error deleting user: " + e.getMessage());
        }
    }
}
