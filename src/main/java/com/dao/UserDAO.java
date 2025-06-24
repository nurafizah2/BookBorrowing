package com.dao;

import java.sql.*;
import com.model.User;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import java.util.logging.Logger;
import java.util.logging.Level;
/**
 *
 * @author Nazihah
 */
public class UserDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/borrowing_book_system?useSSL=false&serverTimezone=UTC";
    private final String dbUser = "root";
    private final String dbPassword = "admin"; 
    
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());
    
    private static final String INSERT_USER = "INSERT INTO users(full_name, username, email, password, role) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_USER_BY_USERNAME = "SELECT * FROM users WHERE username = ?";
    private static final String SELECT_ALL_USERS = "SELECT * FROM users";
    private static final String SELECT_USER_BY_ID = "SELECT full_name, email FROM users WHERE user_id = ?";
    private static final String UPDATE_USER_EMAIL = "UPDATE users SET email = ? WHERE user_id = ?";  //admin side
    private static final String UPDATE_EMAIL_PROFILE = "UPDATE users SET email = ?, profile_picture = ? WHERE user_id = ?";
    private static final String UPDATE_EMAIL = "UPDATE users SET email = ? WHERE user_id = ?";   //user side
    private static final String UPDATE_PROFILE = "UPDATE users SET profile_picture = ? WHERE user_id = ?";
    private static final String COUNT_TOTAL_USERS = "SELECT COUNT(*) FROM users";
    private static final String DELETE_BORROWING_APPROVALS = "DELETE FROM borrowing_approval WHERE user_id = ?";
    private static final String DELETE_USER = "DELETE FROM users WHERE user_id = ?";
    private static final String CHECK_EMAIL_EXISTS = "SELECT COUNT(*) FROM users WHERE email = ?";
    private static final String CHECK_EMAIL_EXISTS_BY_OTHER = "SELECT user_id FROM users WHERE email = ? AND user_id != ?";
    private static final String SEARCH_USERS_BY_USERNAME = "SELECT * FROM users WHERE username LIKE ?";
    private static final String SEARCH_USERNAMES = "SELECT username FROM users WHERE username LIKE ? LIMIT 10";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
             logger.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
        }
        return DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    }

    public boolean registerUser(User user) {
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(INSERT_USER)) {

            stmt.setString(1, user.getFullname());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getRole());

            stmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error registering user", e);
            return false;
        }
    }

    public User loginUser(String username, String password) {
        try (Connection conn = getConnection();
            PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_USERNAME)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (BCrypt.checkpw(password, hashedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullname(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setProfile_picture(rs.getString("profile_picture"));
                    return user;
                }
            }
        } catch (SQLException e) {
             logger.log(Level.SEVERE, "Error logging in user", e);
        }
        return null;
    }

    public List<User> getAllUsers() throws Exception {
        List<User> userList = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setFullname(rs.getString("full_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                userList.add(user);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching all users", e);
            throw e;
        }
        return userList;
    }

    public User getUserById(int userId) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_USER_BY_ID)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setFullname(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    return user;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving user by ID", e);
            throw e;
        }
        return null;
    }

    public int getTotalUsers() throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_TOTAL_USERS);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public void updateEmail(int id, String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_USER_EMAIL)) {

            stmt.setString(1, email);
            stmt.setInt(2, id);
            stmt.executeUpdate();

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user email", e);
        }
    }

    public void deleteUser(int userId) {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement stmt1 = conn.prepareStatement(DELETE_BORROWING_APPROVALS);
                 PreparedStatement stmt2 = conn.prepareStatement(DELETE_USER)) {

                stmt1.setInt(1, userId);
                stmt1.executeUpdate();

                stmt2.setInt(1, userId);
                stmt2.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting user", e);
        }
    }

    public boolean isEmailTaken(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_EMAIL_EXISTS)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            return rs.next() && rs.getInt(1) > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if email is taken", e);
        }
        return false;
    }
    public boolean isEmailTakenByOtherUser(String email, int userId) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_EMAIL_EXISTS_BY_OTHER)) {

            stmt.setString(1, email);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            return rs.next();

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if email is taken by another user", e);
        }
        return false;
    }

    public List<User> searchUsersByUsername(String username) {
        List<User> list = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SEARCH_USERS_BY_USERNAME)) {

            stmt.setString(1, "%" + username + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setFullname(rs.getString("full_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                list.add(user);
            }

        } catch (SQLException e) {
           logger.log(Level.SEVERE, "Error searching users by username", e);
        }

        return list;
    }

    public List<String> searchUsernames(String keyword) {
        List<String> usernames = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SEARCH_USERNAMES)) {

            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                usernames.add(rs.getString("username"));
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching usernames", e);
        }

        return usernames;
    }
    
    public void updateUserProfile(int userId, String email, String profile_picture) throws SQLException {
        String sql;
           if (email != null && profile_picture != null) {
            sql = UPDATE_EMAIL_PROFILE;
        } else if (email != null) {
            sql = UPDATE_EMAIL;
        } else if (profile_picture != null) {
            sql = UPDATE_PROFILE;
        } else {
            return;
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
             if (email != null && profile_picture != null) {
                stmt.setString(1, email);
                stmt.setString(2, profile_picture);
                stmt.setInt(3, userId);
             } else if (email != null) {
                stmt.setString(1, email);
                stmt.setInt(2, userId);
             } else if (profile_picture != null) {
                stmt.setString(1, profile_picture);
                stmt.setInt(2, userId);
             }
                stmt.executeUpdate();
        }
    }   

}

