package com.controller;

import com.dao.BookDAO;
import com.dao.BorrowDAO;
import com.model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import com.model.Notification;
import com.model.User;
import jakarta.servlet.RequestDispatcher;

/**
 *
 * @author Nurafizah
 */
public class UserHomeServlet extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = currentUser.getId(); 

        BorrowDAO dao = new BorrowDAO();
        List<Notification> notifications = dao.getNotificationsByUserId(userId);

        BookDAO bookDao = new BookDAO(); 
        for (Notification note : notifications) {
            int bookId = note.getBookId(); 

            Book book = bookDao.getBookById(bookId); 
            if (book != null) {
                note.setBookTitle(book.getTitle());       
                note.setAuthor(book.getAuthor());     
            }
        }

            request.setAttribute("notifications", notifications);

            int unreadCount = dao.getUnreadNotificationCount(userId);
            request.setAttribute("unreadCount", unreadCount);

            RequestDispatcher dispatcher = request.getRequestDispatcher("user_home.jsp");
            dispatcher.forward(request, response);
    }
}
