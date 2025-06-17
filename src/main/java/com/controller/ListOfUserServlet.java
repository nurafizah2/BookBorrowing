package com.controller;

import com.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import com.dao.UserDAO;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Nurafizah
 */
public class ListOfUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String search = request.getParameter("search"); 
            UserDAO userDAO = new UserDAO();
            List<User> users;

            if (search != null && !search.trim().isEmpty()) {
                users = userDAO.searchUsersByUsername(search);
            } else {
                users = userDAO.getAllUsers();
            }

            request.setAttribute("userList", users);
            request.setAttribute("search", search); 
            request.getRequestDispatcher("list_of_user.jsp").forward(request, response);

        } catch (Exception ex) {
            Logger.getLogger(ListOfUserServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
