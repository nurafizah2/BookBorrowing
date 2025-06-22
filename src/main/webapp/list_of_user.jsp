<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <title>User List</title>
    <style>
       
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            box-sizing: border-box;
 
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }
        
        h1 {
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 8px 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
          
        }

        th {
            background-color: #f5f5f5;
        }

        td {
            height: 5px;
            overflow: hidden;
            line-height: 5px;
        }
        
        tr:hover {
            background-color: #f1f1f1;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .actions a {
            margin-right: 10px;
            color: blue;
        }

        .main-content {
            flex: 1; 
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
   
       .suggestion-container {
            position: relative;
            display: inline-block;
            width: 185px;
        }

        .suggestions-box {
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            border: 1px solid #ccc;
            max-height: 150px;
            overflow-y: auto;
            background: white;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-top: none;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius:10px;
        }

        .suggestions-box div {
            padding: 8px 20px;
            cursor: pointer;

        }

        .suggestions-box div:hover {
            background-color: #f0f0f0;
        }

        
        form {
            margin: 20px 0; 
            text-align: center;
            border:none;  
        }
        
        .submitbtn {
            padding: 7px 16px; 
            color: whitesmoke;
            background: #3e8e41;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .submitbtn:hover {
            background-color: #367c39;
        }
        
        .submitbtn {
            transition: background-color 0.3s ease;
        }
        
        .clearbtn {
            margin-left: 10px; 
            padding: 8px 16px; 
            background: #ccc; 
            text-decoration: none; 
            border-radius: 4px; 
        }
        
        .update-email-form {
            display: flex;
            flex-direction: column;
        }

        .email-input-group {
            display: flex;
             align-items: center;
        }

        .email-input {
            flex: 1;
            padding: 5px;
        }

        .update-btn {
            margin-left: 5px;
            padding: 5px 10px;
            background-color: #00755e;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 3px;
        }

        .error-message {
            color: red;
            font-size: 0.9em;
            margin-top: 5px;
        }
        .scrollable-table {
            max-height: 500px;
            overflow-y: auto;
            width: 100%;
            border: none;
        }

        #searchInput {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            outline: none;
        }
   
    </style>
</head>

<body>
    <div class="lms-title">
        <div class="spacer"></div>
        <span class="title-text">Whisperwood Library</span>
        <img src="images/logo4.png" alt="whisperwood_logo" class="logo">
    </div>
    <div class="wrapper">
        <div class="dashboard">
            <aside class="sidebar">
                <h2>Admin Panel</h2>
                <p class="welcome">Hi, ${currentUser.username}!</p>
                <nav>
                    <ul>
                        <li><a href="AdminHome">Home</a></li>  
                        <li class="has-submenu">
                            <button class="dropdown-btn">Manage Books <i class="arrow down"></i></button>
                            <ul class="submenu">
                                <li><a href="add_book.jsp">Add Book</a></li>
                                <li><a href="ListBooksServlet">Update Book</a></li>
                            </ul>
                        </li>
                        <li><a href="ListOfUserServlet">Manage Users</a></li>
                        <li><a href="ReturnBookServlet"> Returned Book History</a></li>
                        <li><a href="#" onclick="confirmLogout(event)">Logout</a></li>
                    </ul>
                </nav>
            </aside>

        <c:if test="${param.success == 'true'}">
           <script>
               alert("✅ Email updated successfully!");
           </script>
        </c:if>

            <div class="main-content">
                <h2>📋 Registered Users</h2>

                <form method="get" action="ListOfUserServlet" class="form">
                    <div class="suggestion-container">
                        <input type="text" id="searchInput" name="search" placeholder="Search by username..." autocomplete="off" />
                        <div id="suggestions" class="suggestions-box"></div>
                    </div>    &nbsp; &nbsp; &nbsp;
                    <button type="submit" class="submitbtn">Search</button>
                    <c:if test="${not empty param.search}">
                        <a href="ListOfUserServlet" class="clearbtn">Clear</a>
                    </c:if>
                </form>
                
                <div class="scrollable-table">
                    <table>
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${userList}">
                                <tr>
                                    <td>${user.id}</td>
                                    <td>${user.fullname}</td>
                                    <td>${user.username}</td>
                                    <td>
                                        <form action="UpdateEmailServlet" method="post" class="update-email-form">
                                            <input type="hidden" name="id" value="${user.id}" />
                                            <div class="email-input-group">
                                                <input type="email" name="email" value="${user.email}" required class="email-input"  />
                                                <input type="submit" value="Update" class="update-btn" />
                                            </div>
                                            <c:if test="${param.id == user.id || errorUserId == user.id}">
                                                <span class="error-message">${error}</span>
                                            </c:if>
                                        </form>
                                    </td>
                                    <td>${user.role}</td>
                                    <td class="actions">
                                        <a href="DeleteUserServlet?id=${user.id}" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
                
    <%@ include file="footer.jsp" %>    
    <script>
        function confirmLogout(event) {
          event.preventDefault();
          if (confirm("Are you sure you want to logout?")) {
            window.location.href = "LogoutServlet";
          }
        }

        document.addEventListener("DOMContentLoaded", function () {
            // Dropdown toggle for side menu
            const dropdownBtns = document.querySelectorAll(".dropdown-btn");
            dropdownBtns.forEach(btn => {
              btn.addEventListener("click", function (e) {
                e.preventDefault();
                const submenu = this.nextElementSibling;
                submenu.classList.toggle("show");

                this.querySelector(".arrow")?.classList.toggle("open");
              });
            });

        // Username autosuggest
            const input = document.getElementById("searchInput");
            const suggestionBox = document.getElementById("suggestions");

            if (input && suggestionBox) {
                input.addEventListener("input", function () {
                const keyword = this.value;
                if (keyword.length === 0) {
                  suggestionBox.innerHTML = "";
                  return;
                }

                fetch("UsernameAutoSuggestServlet?keyword=" + encodeURIComponent(keyword))
                  .then(response => response.json())
                  .then(data => {
                    suggestionBox.innerHTML = "";
                    data.forEach(username => {
                        const div = document.createElement("div");
                        div.textContent = username;
                        div.addEventListener("click", () => {
                            input.value = username;
                            suggestionBox.innerHTML = "";
                        });
                       suggestionBox.appendChild(div);
                    });
                });
            });

                document.addEventListener("click", (e) => {
                    if (e.target !== input) suggestionBox.innerHTML = "";
                });
            }
        });
    </script>
</body>
</html>
