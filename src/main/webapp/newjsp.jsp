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
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }