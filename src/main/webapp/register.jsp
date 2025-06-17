<%-- 
    Document   : register
    Created on : 21 May 2025, 6:28:06 PM
    Author     : Nazihah
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" href="css/auth-style.css">
</head>
<body>
    <h1 class="lms-title">Welcome to Whisperwood Library</h1>

    <div class="auth-card">
        <h2>Register</h2>
        <form action="RegisterServlet" method="post">
            <input type="text" name="fullname" placeholder="Full name" required>
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>

            <div class="password-container">
                <input type="password" id="passwordField" name="password" placeholder="Password" required>
                <button type="button" class="toggle-password" onclick="togglePassword()">
                    <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
                        <path d="M572.52 241.4C518.1 135.5 407.5 64 288 64S57.9 135.5 3.48 241.4a48.35 48.35 0 000 29.2C57.9 376.5 168.5 448 288 448s230.1-71.5 284.5-177.4a48.35 48.35 0 000-29.2zM288 400c-97.2 0-189.4-57.2-240-144 50.6-86.8 142.8-144 240-144s189.4 57.2 240 144c-50.6 86.8-142.8 144-240 144zm0-240a96 96 0 1096 96 96 96 0 00-96-96zm0 144a48 48 0 1148-48 48 48 0 01-48 48z"/>
                    </svg>
                </button>
            </div>

            <select name="role" required>
                <option value="" disabled selected>Select your role</option>
                <option value="member">Member</option>
                <option value="admin">Admin</option>
            </select>

            <input type="submit" value="Register">
        </form>
        <p class="auth-switch">Already have an account? <a href="login.jsp">Login here</a></p>
    </div>

    <script>
        function togglePassword() {
            const pwd = document.getElementById("passwordField");
            pwd.type = (pwd.type === "password") ? "text" : "password";
        }
    </script>
    </body>
</html>


