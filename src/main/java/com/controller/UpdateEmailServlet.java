package com.controller;

import com.dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nurafizah
 */

public class UpdateEmailServlet extends HttpServlet {

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String email = request.getParameter("email");

        UserDAO dao = new UserDAO();
      
        if (dao.isEmailTakenByOtherUser(email, id)) {               // Check if email is already taken by another user
            request.setAttribute("errorUserId", id); // For highlighting which row failed
            request.setAttribute("error", "Email is already in use by another user.");
            request.getRequestDispatcher("ListOfUserServlet").forward(request, response);
        } else {
            dao.updateEmail(id, email);
            response.sendRedirect("ListOfUserServlet?success=true");
        }
    }
}


