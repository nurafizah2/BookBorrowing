package com.controller;

import com.model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import com.dao.BookDAO;
import com.dao.BorrowDAO;
import com.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

/**
 *
 * @author Nurafizah
 */

public class MyBorrowingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookIdParam = request.getParameter("bookId");

        BookDAO bookDAO = new BookDAO();

        List<Book> bookList = bookDAO.getAllBooks();
        request.setAttribute("bookList", bookList); 

        if (bookIdParam != null && !bookIdParam.isEmpty()) {
            int bookId = Integer.parseInt(bookIdParam);
            request.setAttribute("selectedBookId", bookId);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("my_borrowing.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser"); 

        int bookId = Integer.parseInt(request.getParameter("bookTitle"));
        String borrowDate = request.getParameter("borrowDate");
        int userId = user.getId();

        BorrowDAO dao = new BorrowDAO();
        try {
            dao.insertBorrowRequest(bookId, borrowDate, "PENDING", null, userId);

            BookDAO bookDAO = new BookDAO();    
            bookDAO.updateBookAvailability(bookId, "unavailable");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
        response.sendRedirect("user_home.jsp?request=success");
    }
}
