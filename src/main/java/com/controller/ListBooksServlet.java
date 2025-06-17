package com.controller;

import com.dao.BookDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import com.model.Book;
/**
 *
 * @author Saidatul
 */
public class ListBooksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            BookDAO dao = new BookDAO();
            List<Book> bookList = dao.getAllBooksDetailed();
            request.setAttribute("bookList", bookList);
            request.getRequestDispatcher("listbooks.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error retrieving book list", e);
        }
    }  
}