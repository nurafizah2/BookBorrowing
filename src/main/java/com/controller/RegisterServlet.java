package com.controller;

import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.dao.UserDAO;
import com.model.User;

/**
 * 
 * @author Nazihah
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("RegisterServlet called");
        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        User user = new User();
        user.setFullname(fullname);
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setRole(role);

        UserDAO userDAO = new UserDAO();
        boolean result = userDAO.registerUser(user);

        if (result) {
            System.out.println("✅ Registration successful");
            response.sendRedirect("login.jsp?success=true");
        } else {
            System.out.println("❌ Registration failed in RegisterServlet");
            response.getWriter().println("Registration failed. Check server logs for error.");
        }}}

