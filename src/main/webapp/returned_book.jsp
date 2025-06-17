<%-- 
    Document   : returned_book
    Created on : Jun 16, 2025, 3:40:43 PM
    Author     : USER
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.model.User" %>

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
    <title>Returned Books</title>
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
    h3 {
        text-align: center;
    }

         table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 8px 10px;
             text-align: center;
            border-bottom: 1px solid #ddd;
          
        }

        th {
            background-color: #f5f5f5;
        }

        td {
    height: 5px;
    overflow: hidden;
  line-height: 5px;
  padding: 20px 0px;

  }
        

        tr:hover {
            background-color: #f1f1f1;
        }
</style>

</head>
<body>
    <div class="wrapper">
        <div class="lms-title">
            <div class="spacer"></div>
            <span class="title-text">Whisperwood Library</span>
            <img src="images/logo4.png" alt="whisperwood_logo" class="logo">
        </div>

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
                         <li><a href="ReturnBookServlet"> Returned Book History</a></li>
                        <li><a href="ListOfUserServlet">Manage Users</a></li>
                        <li><a href="#" onclick="confirmLogout(event)">Logout</a></li>
                    </ul>
                </nav>
            </aside>

            <main class="container mt-4">
                <h3>📚 Returned Books</h3>

                <c:if test="${empty returnedList}">
                    <p style="color: red;">No returned books found.</p>
                </c:if>

                <c:if test="${not empty returnedList}">
                    <table>
                        <thead>
                            <tr>
                                <th>Borrow ID</th>
                                <th>User</th>
                                <th>Book ID</th>
                                <th>Book Title</th>
                                <th>Borrow Date</th>
                                <th>Return Date</th>
                                <th>Actual Return Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="borrow" items="${returnedList}">
                                <tr>
                                    <td>${borrow.id}</td>
                                    <td>${borrow.fullName}</td>
                                    <td>${borrow.bookId}</td>
                                    <td>${borrow.bookTitle}</td>
                                    <td>${borrow.borrowDate}</td>
                                    <td>${borrow.returnDate}</td>
                                    <td>${borrow.actualReturnDate}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </main>
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
            const dropdownBtns = document.querySelectorAll(".dropdown-btn");
            dropdownBtns.forEach(btn => {
                btn.addEventListener("click", function () {
                    const submenu = this.nextElementSibling;
                    submenu.classList.toggle("show");
                    this.querySelector(".arrow")?.classList.toggle("open");
                });
            });
        });
    </script>
</body>
</html>
