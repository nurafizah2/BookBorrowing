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
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <title>Returned Books</title>
    
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #d6f3f0;
        height: 100vh;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
    }

    h3 {
        text-align: center;
        font-size: 25px;
        margin-top: 30px;
        font-family: 'Merriweather', serif;
        font-weight: bold;
    }

     .main-content {
            flex: 1; 
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: white;
    }

    th, td {
        padding: 8px 10px;
        text-align: center;
        border: 1px solid #ddd;
    }

    th {
        background-color: #f9e8af;
    }

    tr:hover {
        background-color: #f1f1f1;
    }

    .scrollable-table {
            max-height: 500px;
            overflow-y: auto;
            width: 100%;
            border: none;
        }


    @media (max-width: 768px) {
  

        th, td {
            font-size: 14px;
        }

        h3 {
            font-size: 22px;
        }
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
                            <li><a href="ListOfUserServlet">Manage Users</a></li>
                            <li><a href="ReturnBookServlet"> Returned Book History</a></li>
                            <li><a href="#" onclick="confirmLogout(event)">Logout</a></li>
                        </ul>
                    </nav>
                </aside>

                    <div class="main-content">
                    <h3>📚 Returned Books History</h3>


                    <c:if test="${empty returnedList}">
                        <p style="color: red;">No returned books found.</p>
                    </c:if>

                    <c:if test="${not empty returnedList}">
                          <div class="scrollable-table">
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
                         </div>
                    </c:if>
              
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
