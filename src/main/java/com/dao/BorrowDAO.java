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
    private static final String INSERT_NOTIFICATION = "INSERT INTO notifications (user_id, book_id, message) VALUES (?, ?, ?)";
    private static final String SELECT_ALL_PENDING_REQUESTS = "SELECT ba.book_approval_id, ba.book_id, b.title AS book_title, ba.borrow_date, ba.return_date, ba.status, u.full_name, u.email, u.user_id " +
                                                              "FROM borrowing_approval ba " +
                                                              "JOIN users u ON ba.user_id = u.user_id " +
                                                              "JOIN book b ON ba.book_id = b.book_id " +
                                                              "ORDER BY ba.status DESC, ba.borrow_date ASC";
    
    private static final String SELECT_RECENT_BORROW_REQUEST = "SELECT br.book_approval_id, br.book_id, b.title, u.full_name, u.username, u.email, " +
                                                               "br.borrow_date, br.return_date, br.status, br.user_id " +
                                                               "FROM borrowing_approval br " +
                                                               "JOIN users u ON br.user_id = u.user_id " +
                                                               "JOIN book b ON br.book_id = b.book_id " +
                                                               "ORDER BY br.borrow_date DESC LIMIT 5";
    
    private static final String SELECT_APPROVED_REQUEST_WITH_DETAILS = "SELECT ba.book_approval_id, ba.status, ba.return_date, ba.book_id, "+
                                                                       "b.title AS book_title, u.full_name, u.email, ba.actual_return_date "+
                                                                       "FROM borrowing_approval ba "+
                                                                       "JOIN book b ON ba.book_id = b.book_id "+
                                                                       "JOIN users u ON ba.user_id = u.user_id "+
                                                                       "WHERE ba.status = 'APPROVED' "+
                                                                       "ORDER BY ba.return_date DESC";
    
    private static final String SELECT_BORROW_REQUEST_WITH_DETAIL = "SELECT book_approval_id, book_id, user_id, status, return_date, actual_return_date FROM borrowing_approval WHERE user_id = ?";
    private static final String SELECT_TOTAL_PENDING_REQUEST = "SELECT COUNT(*) FROM borrowing_approval WHERE status = 'PENDING'";
    private static final String SELECT_APPROVED_REQUEST = "SELECT COUNT(*) FROM borrowing_approval WHERE status = 'APPROVED' ";
    private static final String SELECT_NOTIFICATION_BY_USER_ID = "SELECT id, book_id, message, created_at, is_read FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
    private static final String SELECT_UNREAD_NOTIFICATION = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = false";
    private static final String SELECT_RETURN_BOOK = "SELECT ba.*, b.book_id AS book_id, b.title AS book_title, u.full_name AS full_name " +
                                                     "FROM borrowing_approval ba " +
                                                     "JOIN book b ON ba.book_id = b.book_id " +
                                                     "JOIN users u ON ba.user_id = u.user_id " +
                                                     "WHERE ba.status = 'APPROVED' AND ba.actual_return_date IS NOT NULL "+
                                                     "ORDER BY ba.actual_return_date DESC";

    private static final String UPDATE_STATUS_APPROVED = "UPDATE borrowing_approval SET status = ?, return_date = ? WHERE book_approval_id = ?";
    private static final String UPDATE_STATUS_REJECTED = "UPDATE borrowing_approval SET status = ? WHERE book_approval_id = ?";
    private static final String UPDATE_RETURN_BOOK = "UPDATE borrowing_approval SET actual_return_date = CURRENT_DATE WHERE book_approval_id = ?";
    private static final String UPDATE_AVAILABILITY = "UPDATE book SET availability = 'available' WHERE book_id = (SELECT book_id FROM borrowing_approval WHERE book_approval_id = ?)";
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

    public void insertBorrowRequest(int bookId, String borrowDate, String status, String returnDate, int userId) throws SQLException {
        String sql = INSERT_BORROW_REQUEST;
        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, bookId);
                ps.setString(2, borrowDate);
                ps.setString(3, status);
                ps.setString(4, returnDate); 
                ps.setInt(5, userId);
                ps.executeUpdate();
        }
    }
    
    public void sendNotification(int userId, int bookId, String message) throws Exception {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_NOTIFICATION)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.setString(3, message);
            stmt.executeUpdate();
        }
    }

    public List<BorrowApproval> getAllPendingRequests() throws Exception {
        List<BorrowApproval> requests = new ArrayList<>();

           try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(SELECT_ALL_PENDING_REQUESTS)){

                    while (rs.next()) {
                       BorrowApproval r = new BorrowApproval();
                        r.setId(rs.getInt("book_approval_id"));
                        r.setBookId(rs.getInt("book_id"));
                        r.setBookTitle(rs.getString("book_title"));
                        r.setUserId(rs.getInt("user_id"));
                        r.setEmail(rs.getString("email"));
                        r.setFullName(rs.getString("full_name"));
                        r.setBorrowDate(rs.getDate("borrow_date"));
                        r.setReturnDate(rs.getDate("return_date"));
                        r.setStatus(Status.valueOf(rs.getString("status")));
                        requests.add(r);
                    }
                }
        return requests;
    }

    public int getPendingRequestsCount() throws SQLException {
        String sql = SELECT_TOTAL_PENDING_REQUEST;
        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getBorrowedBooks() throws SQLException {
        String sql = SELECT_APPROVED_REQUEST;
        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<BorrowApproval> getRecentBorrowRequests() throws SQLException {
        List<BorrowApproval> list = new ArrayList<>();
        String sql = SELECT_RECENT_BORROW_REQUEST;

        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BorrowApproval br = new BorrowApproval();
                br.setId(rs.getInt("book_approval_id"));
                br.setBookId(rs.getInt("book_id"));
                br.setBookTitle(rs.getString("title"));
                br.setFullName(rs.getString("full_name"));
                br.setUsername(rs.getString("username"));
                br.setEmail(rs.getString("email"));
                br.setBorrowDate(rs.getDate("borrow_date"));
                br.setReturnDate(rs.getDate("return_date"));
                String statusStr = rs.getString("status");

                if (statusStr != null) {
                    try {
                        br.setStatus(BorrowApproval.Status.valueOf(statusStr));
                    } catch (IllegalArgumentException e) {
                        br.setStatus(BorrowApproval.Status.PENDING); // default fallback
                    }
                }
                br.setUserId(rs.getInt("user_id"));
                list.add(br);
            }
        }
        return list;
    }

    public List<BorrowApproval> getApprovedBorrowRequests() throws SQLException {
        List<BorrowApproval> list = new ArrayList<>();
        String sql = SELECT_APPROVED_REQUEST_WITH_DETAILS;

        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowApproval ba = new BorrowApproval();
                    ba.setId(rs.getInt("book_approval_id"));
                    ba.setBookId(rs.getInt("book_id"));
                    ba.setStatus(Status.valueOf(rs.getString("status")));
                    ba.setBookTitle(rs.getString("book_title"));
                    ba.setFullName(rs.getString("full_name"));
                    ba.setEmail(rs.getString("email"));
                    ba.setReturnDate(rs.getDate("return_date"));
                    ba.setActualReturnDate(rs.getDate("actual_return_date"));
                    list.add(ba);
                }
        }
        return list;
    }

    public List<BorrowApproval> getBorrowActualReturnDate(int userId) throws SQLException {
        List<BorrowApproval> list = new ArrayList<>();
        String sql = SELECT_BORROW_REQUEST_WITH_DETAIL;
        try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)){
                ps.setInt(1, userId);
                try(ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        BorrowApproval ba = new BorrowApproval();
                        ba.setId(rs.getInt("book_approval_id"));
                        ba.setBookId(rs.getInt("book_id"));
                        ba.setUserId(rs.getInt("user_id"));
                        ba.setStatus(Status.valueOf(rs.getString("status")));
                        ba.setReturnDate(rs.getDate("return_date"));
                        ba.setActualReturnDate(rs.getDate("actual_return_date"));
                        list.add(ba);
                    }
                }
            }
        return list;
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
                    note.setBookId(rs.getInt("book_id"));
                    note.setMessage(rs.getString("message"));
                    note.setTimeStamp(rs.getTimestamp("created_at"));
                    note.setIsRead(rs.getBoolean("is_read"));
                    
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

    public boolean markBookAsReturned(int borrowId) {
        String sqlUpdateReturn = UPDATE_RETURN_BOOK;
         String sqlUpdateAvailability = UPDATE_AVAILABILITY;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (
                PreparedStatement stmt1 = conn.prepareStatement(sqlUpdateReturn);
                     PreparedStatement stmt3 = conn.prepareStatement(sqlUpdateAvailability);
            ) {
                stmt1.setInt(1, borrowId);
                stmt1.executeUpdate();
                stmt3.setInt(1, borrowId);
                stmt3.executeUpdate();
                conn.commit();
                
                return true;   
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    
    public void updateStatus(int requestId, String status, LocalDate returnDate) throws SQLException {
       String sql;

        if ("APPROVED".equals(status)) {
            sql = UPDATE_STATUS_APPROVED;
        } else {
            sql = UPDATE_STATUS_REJECTED;
        }

        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);

                if ("APPROVED".equals(status)) {
                   stmt.setDate(2, java.sql.Date.valueOf(returnDate));
                   stmt.setInt(3, requestId);
                } else {
                   stmt.setInt(2, requestId);
                }
                stmt.executeUpdate();
        }
    }  
      
    public void markNotificationAsRead(int notificationId) throws Exception {
        String sql = UPDATE_READ_NOTIFICATION; 
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        }
    }
      
    public void deleteRequest(int requestId) throws Exception {
        String sql = DELETE_REQUEST;
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, requestId);
            stmt.executeUpdate();
        }
    }
    
    public List<BorrowApproval> getReturnedBooks() throws SQLException {
       List<BorrowApproval> list = new ArrayList<>();
       String sql = SELECT_RETURN_BOOK;

       try (Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
           while (rs.next()) {
               BorrowApproval ba = new BorrowApproval();
               ba.setId(rs.getInt("book_approval_id"));
               ba.setBookId(rs.getInt("book_id")); 
               ba.setBookTitle(rs.getString("book_title"));
               ba.setFullName(rs.getString("full_name"));
               ba.setBorrowDate(rs.getDate("borrow_date"));
               ba.setReturnDate(rs.getDate("return_date"));
               ba.setActualReturnDate(rs.getDate("actual_return_date"));
               list.add(ba);
           }
       }
       return list;
   }


}
