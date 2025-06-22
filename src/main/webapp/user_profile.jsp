<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.model.User user = (com.model.User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Kanit:ital,wght@0,400;1,400;1,700&display=Merriweather&family=swap">
    <link rel="stylesheet" href="css/header-footer.css" >
    <title>User Profile</title>

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;         
        }
        
        body {
            display: flex;
            flex-direction: column;
            font-family: 'Merriweather', sans-serif;
        }

        .main {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 15px;
        }

        .profile-card {
            background-color: #fff;
            width: 100%;
            max-width: 400px;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
        }

        h1.page-title {
            text-align: center;
            margin: 10px 0;
            color: white;
            font-size: 2rem;
            font-style: italic;
            font-weight: 600;
            font-family: Kanit;
        }

        .info {
            margin-bottom: 15px;
            text-align: left;
        }

        .info span {
            font-weight: bold;
            color: #333;
        }

        .profile-card input[type="email"],
        .profile-card input[type="file"] {
            width: 100%;
            margin-top: 5px;
        }

        .btn-primary {
            width: 100%;
        }
        
    </style>
</head>

<body>
    <header class="navbar">
        <div class="left-section">
            <div class="burger-menu" onclick="toggleMenu()">
                <span></span><span></span><span></span>
                <nav class="nav-links" id="navLinks">
                    <a href="user_home.jsp">Home</a>
                    <a href="BookCatalogProcessing">Book Catalog</a>
                    <a href="MyBorrowingServlet">My Borrowing</a>
                    <a href="#" onclick="confirmLogout(event)">Logout</a>
                </nav>
            </div>
        </div>

        <div class="center">
            <h1 class="page-title">Whisperwood Library</h1>
        </div>

        <div class="right-section">
            <a href="user_profile.jsp">
                <img src="images/profile.png" alt="Profile" class="profile-icon">
            </a>
        </div>
    </header>

    <%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    %>

    <% if (success != null) { %>
        <div class="alert alert-success text-center w-100" role="alert">
            Profile updated successfully!
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger text-center w-100" role="alert">
            Failed to update profile. Please try again.
        </div>
    <% } %>

    <div class="main">
        <div class="profile-card">
            <form action="UserProfileServlet" method="post" enctype="multipart/form-data">
                <img src="<%= (user != null && user.getProfile_picture() != null) ? user.getProfile_picture() : "images/profile2.png" %>" alt="User Avatar" class="avatar">

                <div class="info"><span>Username:</span> <%= (user != null) ? user.getUsername() : "" %></div>
                <div class="info"><span>Full Name:</span> <%= (user != null) ? user.getFullname() : "" %></div>

                <div class="info">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" class="form-control" value="<%= (user != null) ? user.getEmail() : "" %>" required>
                </div>

                <div class="info">
                    <label for="profileImage">Change Profile Picture:</label>
                    <input type="file" name="profileImage" id="profileImage" accept="image/*">
                </div>

                <button type="submit" class="btn btn-primary">Update Profile</button>
            </form>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="js/user_js.js"></script>
</body>
</html>
