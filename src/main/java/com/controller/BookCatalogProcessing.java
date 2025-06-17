package com.controller;

import com.dao.BookDAO;
import com.model.Book;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
/**
 *
 * @author Nurafizah
 */
public class BookCatalogProcessing extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String bookIdParam = request.getParameter("bookId");

        if (bookIdParam != null) {
            int bookId = Integer.parseInt(bookIdParam);
            Book book = bookDAO.getBookById(bookId);
            request.setAttribute("book", book);
            RequestDispatcher dispatcher = request.getRequestDispatcher("book_details.jsp");
            dispatcher.forward(request, response);
        } else {
            String keyword = request.getParameter("keyword");
            List<Book> bookList = bookDAO.getBooks(keyword);

                if (keyword == null || keyword.trim().isEmpty()) {
                    Collections.shuffle(bookList);
                }
                
            request.setAttribute("bookList", bookList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("book_catalog.jsp");
            dispatcher.forward(request, response);
        }
    }
}
