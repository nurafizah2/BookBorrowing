<%-- 
    Document   : login
    Created on : 21 May 2025, 6:29:10 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/auth-style.css">
</head>
<body>
    <h1 class="lms-title">Welcome to Whisperwood Library</h1>
    <div class="auth-card">
    <h2>Login</h2>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div style="color:red; margin-bottom: 10px;"><%= errorMessage %></div>
        <%
            }
            String success = request.getParameter("success");
            if ("true".equals(success)) {
        %>
            <div style="color: green; margin-bottom: 10px;">
                ✅ Registration successful! Please login.
            </div>
        <%
            }
        %>

        <form action="LoginServlet" method="post">
            <input type="text" name="username" placeholder="Username" required>

            <div class="password-container">
                <input type="password" id="passwordField" name="password" placeholder="Password" required>
                <button type="button" class="toggle-password" onclick="togglePassword()">
                    <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
                        <path d="M572.52 241.4C518.1 135.5 407.5 64 288 64S57.9 135.5 3.48 241.4a48.35 48.35 0 000 29.2C57.9 376.5 168.5 448 288 448s230.1-71.5 284.5-177.4a48.35 48.35 0 000-29.2zM288 400c-97.2 0-189.4-57.2-240-144 50.6-86.8 142.8-144 240-144s189.4 57.2 240 144c-50.6 86.8-142.8 144-240 144zm0-240a96 96 0 1096 96 96 96 0 00-96-96zm0 144a48 48 0 1148-48 48 48 0 01-48 48z"/>
                    </svg>
                </button>
            </div>
            <input type="submit" value="Login">
        </form>

        <p class="auth-switch">Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>

    <script>
        function togglePassword() {
            const pwd = document.getElementById("passwordField");
            pwd.type = pwd.type === "password" ? "text" : "password";
        }
    </script>
    </body>
</html>



