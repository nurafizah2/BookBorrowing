<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Book" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="css/admin-menu-style.css">
    <title>List of Books</title>
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

        .search-bar-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 10px;
            margin-top: 10px;
        }
        
        .search-bar-container select, .search-bar-container input {
            padding: 10px;
            font-size: 16px;
            border-radius: 4px;
            margin-right: 10px;
            border: 1px solid #ccc;
        }
        
        .search-bar-container button {
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 4px;
            border: none;
            background-color: #f9c41a;
            color: #000;
            cursor: pointer;
        }
        
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        
        th {
            border: 1px solid #aaa;
            padding: 8px;
            text-align: center;
            background-color: #ddd;
        }
        
        td {
            border: 1px solid #aaa;
            padding: 8px;
            text-align: left;
        }
        
        table td:nth-child(1), 
        table td:nth-child(3), 
        table td:nth-child(4),  
        table td:nth-child(5),  
        table td:nth-child(7),  
        table td:nth-child(8),  
        table td:nth-child(9)  
        {
            text-align: center;
        }
        
        table td:nth-child(2), 
        table td:nth-child(6),
        table td:nth-child(10), 
        table td:nth-child(11) {
            text-align: left;
        }
        
        img {
            width: 80px;
            height: 100px;
            object-fit: cover;
            display: block;
        }
        
        .form-container {
            margin: 20px;
            padding: 20px;
            background-color: #fff5d7;
            border: 2px solid #f2d98d;
            box-sizing: border-box;
            flex-grow: 1;
            overflow-y: auto;
        }
        
        .action-buttons {
            display: flex;
            gap: 18px;
        }
        
        .update-delete-btn {
            background-color: #f9c41a;
            color: #000;
            border: none;
            border-radius: 6px;
            padding: 8px 15px;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.2s;
            font-family: inherit;
        }
        
        .update-delete-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .update-delete-btn:hover:not(:disabled) {
            background-color: #eab308;
        }
    
        .edit-inline-group {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-left: 20px; 
        }
        
        .inline-edit-buttons {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }

        .quantity-cell input[type="number"] {
            width: 116px;
            padding: 2px 10px;
            font-size: 15px;
            margin-bottom: 2px;
        }
        
        @media (max-width: 768px) {
            header h1 {
                font-size: 28px;
            }
            table {
                margin-top: 10px;
            }
            .form-container {
                margin: 20px;
                padding: 20px;
            }
            .update-delete-btn{
                font-size: 16px;
                padding: 10px 18px;
            }
        }
        
        h3{
            text-align: center;
            font-family: 'Merriweather', serif;
            font-weight: bold;
            font-size: 25px;
        }
        
        customAlert{
            display: block; 
            position: fixed; 
            top: 20px; 
            left: 50%; 
            transform: translateX(-50%); 
            background: #4CAF50; 
            color: white; 
            padding: 16px 32px; 
            border-radius: 4px; 
            z-index: 9999; 
            font-size: 18px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);  
        }
        
    </style>
</head>

<body>
    <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
    %>
    <div id="customAlert" class="customAlert">
        <%= successMessage %>
    </div>
    <%
            session.removeAttribute("successMessage");
        }
    %>

    <div class="lms-title">
        <div class="spacer"></div>
        <span class="title-text">Whisperwood Library</span>
        <img src="images/logo4.png" alt="whisperwood_logo" class="logo">
    </div>
    
    <div class="wrapper">
        <div class="dashboard">
            <aside class="sidebar">
                <h2>Admin Panel</h2>
                <c:if test="${not empty currentUser}">
                    <p class="welcome">Hi, ${currentUser.username}!</p>
                </c:if>

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

            <div class="form-container">
                <h3>📚 List Book</h3>

                <div class="search-bar-container">
                    <select id="searchField">
                        <option value="all">All</option>
                        <option value="title">Title</option>
                        <option value="author">Author</option>
                        <option value="publisher">Publisher</option>
                    </select>
                    <input type="text" id="searchInput" placeholder="Search books...">
                    <button onclick="searchBooks()">Go</button>
                </div>

                <%
                    List<Book> bookList = (List<Book>) request.getAttribute("bookList");
                    if (bookList == null || bookList.isEmpty()) {
                %>
                    <p>No books found.</p>
                <%
                    } else {
                %>

        <script>
            setTimeout(function() {
                document.getElementById('customAlert').style.display = 'none';
            }, 3000);
        </script>

            <table id="bookTable" border="1">
                <colgroup>
                    <col style="width: 5%;">   <!-- Id -->
                    <col style="width: 10%;">  <!-- Book Cover Image -->
                    <col style="width: 5%;">  <!-- Title -->
                    <col style="width: 5%;">  <!-- Author -->
                    <col style="width: 10%;">  <!-- Publisher -->
                    <col style="width: 10%;">  <!-- ISBN -->
                    <col style="width: 10%;">  <!-- Genre -->
                    <col style="width: 8%;">   <!-- Year Of Publication -->
                    <col style="width: 30%;">  <!-- Book Description -->
                    <col style="width: 5%;">   <!-- Quantity -->
                    <col style="width: 5%;">   <!-- Status -->
                    <col style="width: 7%;">   <!-- Action -->
                </colgroup>
                <tr>
                    <th>Id</th>
                    <th>Book Cover Image</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Publisher</th>
                    <th>ISBN</th>
                    <th>Genre</th>
                    <th>Year Of Publication</th>
                    <th>Book Description</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>

                <c:forEach var="book" items="${bookList}">
                    <tr>
                        <td>${book.bookId}</td>
                        <td><img src="${book.bookCoverImage}" alt="Book Cover" /></td>
                        <td>${book.title}</td>
                        <td>${book.author}</td>
                        <td>${book.publisher}</td>
                        <td>${book.isbn}</td>
                        <td>${book.genre}</td>
                        <td>${book.yearOfPublication}</td>
                        <td>${book.bookDescription}</td>
                        <td>
                            <c:choose>
                                <c:when test="${book.availability == 'AVAILABLE'}">
                                    <span style="color:green;">Available</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:red;">Unavailable</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="UpdateBookAvailabilityServlet" method="post">
                                <input type="hidden" name="bookId" value="${book.bookId}" />
                                <input type="submit" class="update-delete-btn" value="${book.availability == 'AVAILABLE' ? 'Mark as unavailable' : 'Mark as available'}" />
                            </form>
                            <br>
                            <form action="DeleteBookServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this book?');">
                                <input type="hidden" name="bookId" value="${book.bookId}" />
                                <input type="submit" class="update-delete-btn" value="Delete" />
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        <%
            }
        %>
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

        function searchBooks() {
            var input = document.getElementById('searchInput').value.toLowerCase().trim();
            var field = document.getElementById('searchField').value;
            var table = document.getElementById('bookTable');
            var rows = table.getElementsByTagName('tr');

            var fieldMap = {
                'title': 2,
                'author': 3,
                'publisher': 4
            };

            for (var i = 1; i < rows.length; i++) {
                var cells = rows[i].getElementsByTagName('td');
                var found = false;

                if (field === 'all') {
                    for (var j = 0; j < cells.length; j++) {
                        if (cells[j].innerText.toLowerCase().includes(input)) {
                            found = true;
                            break;
                        }
                    }
                } else {
                    var col = fieldMap[field];
                    if (cells[col] && cells[col].innerText.toLowerCase().includes(input)) {
                        found = true;
                    }
                }
                rows[i].style.display = found ? '' : 'none';
            }
        }
        
    </script>
</body>
</html>
