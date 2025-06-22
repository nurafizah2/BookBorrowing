<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <title>Borrow Request Approval</title>
    <style>
        
        .form-container {
            margin: 50px auto;
            width: 500px;
            background-color: #fff5d7;
            padding: 30px 50px;
            border: 2px solid #f2d98d;
        }
        .form-group {
            margin-bottom: 20px;
            font-size: 18px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
        }

        .form-group input[readonly] {
            background-color: #eee;
        }

        .button-group {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
        }

        .button-group button,
        .button-group input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            height: 40px;
        }

        .approve-btn {
            background-color: #27ae60;
            color: #fff;
        }

        .reject-btn {
            background-color: #e74c3c;
            color: #fff;
        }

        .content-area {
            margin-left: 0px; 
            padding: 20px;
            padding-left: 40px;
            background-color: #d6f3f0;
            padding-bottom: 100px; 
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            margin-top: 20px;
            margin-bottom: 20px;
            table-layout: fixed; 
        }
        table th, table td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        table th {
            background-color: #f9e8af;
            padding-top: 5px;
        }
        .scrollable-table {
            max-height: 400px;
            overflow-y: auto;
        }
        .scrollable-table table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .scrollable-table thead th {
            position: sticky;
            top: 0;
            background-color: #f9e8af;
            z-index: 1;
        }
        .scrollable-table th,
        .scrollable-table td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        
        h2{
            text-align: center;
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
                <p class="welcome">Hi, ${currentUser.username}!</p>
                <nav>
                    <ul>
                        <li class="has-submenu">
                            <li><a href="AdminHome">Home</a></li>
                            <button class="dropdown-btn">Manage Books <i class="arrow down"></i></button>
                            <ul class="submenu">
                                <li><a href="add_book.jsp">Add Book</a></li>
                                <li><a href="ListBooksServlet">Update Book</a></li>
                            </ul>
                        <li><a href="ListOfUserServlet">Manage Users</a></li>
                        <li><a href="ReturnBookServlet"> Returned Book History</a></li>
                        <li><a href="#" onclick="confirmLogout(event)">Logout</a></li>
                    </ul>
                </nav>
            </aside>

            <div class="content-area">
                <h2>Borrow Requests</h2>
                <div class="scrollable-table">
                    <table>
                        <colgroup>
                            <col style="width: 8%;">  <!-- ID -->
                            <col style="width: 22%;"> <!-- User -->
                            <col style="width: 8%;"> <!-- Book ID -->
                            <col style="width: 21%;"> <!-- Book -->
                            <col style="width: 11%;"> <!-- Date -->
                            <col style="width: 10%;"> <!-- Status -->
                            <col style="width: 20%;"> <!-- Action -->
                        </colgroup>
                        <thead>
                            <tr>
                                <th>Request ID</th>
                                <th>User</th>
                                <th>Book ID</th>
                                <th>Book</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="request" items="${borrowApproval}">
                                <c:if test="${request.status == 'PENDING'}">
                                    <tr>
                                        <td>${request.id}</td>
                                        <td>${request.fullName} (${request.email})</td>
                                        <td>${request.bookId}</td>
                                        <td>${request.bookTitle}</td>
                                        <td>${request.borrowDate}</td>
                                        <td>${request.status}</td>
                                        <td>
                                            <form action="BorrowApprovalServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${request.id}" />
                                                <input type="hidden" name="bookId" value="${request.bookId}" />
                                                <input type="hidden" name="action" value="APPROVED" />
                                                <input type="hidden" name="userId" value="${request.userId}" />
                                                <input type="date" name="returnDate" required /> <br><br>
                                                <input type="submit" value="Approve" class="approve-btn" />
                                            </form>

                                            <form action="BorrowApprovalServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${request.id}" />
                                                <input type="hidden" name="bookId" value="${request.bookId}" />
                                                <input type="hidden" name="userId" value="${request.userId}" />
                                                <input type="hidden" name="action" value="REJECTED" />
                                                <input type="submit" value="Reject" class="reject-btn" />
                                            </form>
                                        </td>
                                    </tr>
                                </c:if>
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
