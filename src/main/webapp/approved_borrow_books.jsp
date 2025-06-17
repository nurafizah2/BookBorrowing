<%-- 
    Document   : approved_borrow_books
    Created on : Jun 8, 2025, 9:33:01 AM
    Author     : USER
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Approved Borrowed Books</title>
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

        <div class="container mt-4">
            <h3>Approved Borrowed Books</h3>

            <c:if test="${empty approvedList}">
                <p style="color:red;">No approved books found.</p>
            </c:if>

            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Borrow ID</th>
                        <th>Full Name</th>
                        <th>Title</th>
                        <th>Email</th>
                        <th>Return Date</th>
                        <th>Actual Return Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="borrow" items="${approvedList}">
                        <tr>
                            <td>${borrow.id}</td>
                            <td>${borrow.fullName}</td>
                            <td>${borrow.bookTitle}</td>
                            <td>${borrow.email}</td>
                            <td>${borrow.returnDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty borrow.actualReturnDate}">
                                        <form method="post" action="ReturnBookServlet" onsubmit="return confirm('Return this book?')">
                                            <input type="hidden" name="borrowId" value="${borrow.id}" />
                                            <button type="submit" class="btn btn-sm btn-primary">Return</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                         <span class="text-success fw-bold">Returned on: ${borrow.actualReturnDate}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
</div>

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
