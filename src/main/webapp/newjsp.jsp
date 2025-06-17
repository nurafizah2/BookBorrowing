package com.dao;

import com.model.BorrowApproval;
import com.model.BorrowApproval.Status;
import com.model.Notification;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nurafizah
 */

public class BorrowDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/borrowing_book_system?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "admin";

    private static final String INSERT_BORROW_REQUEST = "INSERT INTO borrowing_approval (book_id, borrow_date, status, return_date, user_id) VALUES (?, ?, ?, ?, ?)";
    private static final String INSERT_NOTIFICATION = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
    
    private static final String SELECT_NOTIFICATION_BY_USER_ID = "SELECT id, book_id, message, created_at, is_read FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
    private static final String SELECT_UNREAD_NOTIFICATION = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = false";
   
    private static final String UPDATE_READ_NOTIFICATION = "UPDATE notifications SET is_read = true WHERE id = ?";
    private static final String DELETE_REQUEST = "DELETE FROM borrowing_approval WHERE book_approval_id = ?";
    
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found.");
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

  
    public void sendNotification(int userId, String message) throws Exception {
        String sql = INSERT_NOTIFICATION;
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, message);
            stmt.executeUpdate();
        }
    }

   

    
    
    public List<Notification> getNotificationsByUserId(int userId) {
            List<Notification> notifications = new ArrayList<>();

            try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_NOTIFICATION_BY_USER_ID)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    Notification note = new Notification();
                    note.setId(rs.getInt("id"));
                    note.setMessage(rs.getString("message"));
                    note.setTimeStamp(rs.getTimestamp("created_at"));
                    note.setIsRead(rs.getBoolean("is_read"));
                    note.setBookId(rs.getInt("book_id"));
                    notifications.add(note);
                }

            } catch (SQLException e) {
                e.printStackTrace(); 
            }
        return notifications;
    }

    public int getUnreadNotificationCount(int userId) {
        int count = 0;
        String sql = SELECT_UNREAD_NOTIFICATION;

        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

  

    
   
      
    public void markNotificationAsRead(int notificationId) throws Exception {
        String sql = UPDATE_READ_NOTIFICATION; 
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
      
 