package com.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.dao.UserDAO;
import com.model.User;
import jakarta.servlet.*;
/**
 *
 * @author Nazihah
 */
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();

        User user = userDAO.loginUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);

            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("AdminHome");
            } else if ("member".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("UserHomeServlet");
            } else {
                response.sendRedirect("accessDenied.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password.");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }
}
    

