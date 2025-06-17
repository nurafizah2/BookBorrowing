package com.controller;

import com.dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import com.google.gson.Gson;

/**
 *
 * @author Nurafizah
 */

public class UsernameAutoSuggestServlet extends HttpServlet {

 @Override
 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("keyword");
        UserDAO dao = new UserDAO();
        List<String> matchingUsernames = dao.searchUsernames(keyword);

        response.setContentType("application/json");
        new Gson().toJson(matchingUsernames, response.getWriter());
    }
}

