<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <title>Admin Dashboard</title>
    
    <style>
        
      
    html, body {
        height: 100%;
        margin: 0;
    }
        .cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .card {
            background-color: #f1f1f1;
            padding: 20px;
            border-radius: 8px;
            width: 200px;
            text-align: center;
            box-shadow: 0 0 5px #ccc;
        }
        .card h3 {
            margin-bottom: 10px;
        }

        a {
            color: inherit;      
            text-decoration: none;
        }
        a:hover {
            color: #007bff;
            text-decoration: underline;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table th, table td {
            border: 1px solid #ccc;
            padding: 10px 12px;
            text-align: left;
        }

        table th {
            background-color: #f5f5f5;
        }

        table td a {
            color: #0077cc;
            text-decoration: none;
        }

        table td a:hover {
            text-decoration: underline;
        }

        .card:hover {
            box-shadow: 0 0 10px #bbb;
            transform: translateY(-3px);
            transition: 0.3s;
        }

.content {
            flex: 1; 
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
            padding-bottom: 5px;
        }
   
.dashboard {
    display: flex;
    flex: 1;
    min-height: calc(100vh - 60px); /* Adjust 60px if your header/footer has different height */
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
            <p class="welcome">Hi, <%= user.getUsername() %></p>
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

        <main class="content">
            <h2>📊 Admin Dashboard</h2>
            <div class="cards">
                <a href="ListBooksServlet">
                    <div class="card">
                        <h3>📘 Total Books</h3>
                        <p><strong>${totalBooks}</strong></p>
                    </div>
                </a>
                <a href="ListOfUserServlet">
                    <div class="card">
                        <h3>👤 Total Users</h3>
                        <p><strong>${totalUsers}</strong></p>
                    </div>
                </a>
                <a href="BorrowApprovalServlet">
                    <div class="card">
                        <h3>🕐 Pending Requests</h3>
                        <p><strong>${pendingRequests}</strong></p>
                    </div>
                 </a>
                <a href="ApprovedBorrowedBookServlet">
                    <div class="card">
                        <h3>✅ Borrowed Books</h3>
                        <p><strong>${borrowedBooks}</strong></p>
                    </div>
                </a>
                    

            </div>

            <h3>📝 Recent Borrow Requests</h3>
            <table>
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Book</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${recentRequests}">
                        <tr>
                            <td>${req.fullName}</td>
                            <td>${req.bookTitle}</td>
                            <td>${req.status}</td>
                            <td>${req.borrowDate}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </main>
    </div>
 </div>
<%@ include file="footer.jsp" %>
    <script>
        function confirmLogout(event) {
            event.preventDefault(); // Prevent link from navigating
            if (confirm("Are you sure you want to logout?")) {
                window.location.href = "LogoutServlet"; // Redirect only if confirmed
            }
        }
        
        document.addEventListener("DOMContentLoaded", function () {
          const dropdownBtns = document.querySelectorAll(".dropdown-btn");

          dropdownBtns.forEach(btn => {
            btn.addEventListener("click", function (e) {
              e.preventDefault();
              const submenu = this.nextElementSibling;
              
              submenu.classList.toggle("show");

              const arrow = this.querySelector(".arrow");
              if (arrow) arrow.classList.toggle("open");
            });
          });
        });
        
       
        
    </script>
    </body>
</html>
