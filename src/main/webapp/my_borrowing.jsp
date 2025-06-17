<%-- 
    Author     : Nurafizah
--%>

<%@page import="com.model.Book"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    com.model.User user = (com.model.User) session.getAttribute("currentUser");
    String selectedBookId = request.getParameter("bookId");
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <title>Book Borrowing System</title>
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
       <link href="https://fonts.googleapis.com/css2?family=Kanit:ital,wght@0,400;1,400;1,700&display=Merriweather&family=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/header-footer.css">
       
       
    <style>
          
              h1{
            text-align: center;
            margin-bottom: 6px;
            margin-top: 6px;
            font-family: 'Kanit', serif;
            font-style: italic;
            color: white;
            font-size: 2.0rem;
            font-weight: 600;
        }
        
            
            h3{
                text-align: center;
                font-family: 'Merriweather', serif;
                font-weight: bold;
            }
            .content{

                height: 360px;
                display: flex;                     /* Flexbox! */
                justify-content: center;          /* Horizontally center */
                align-items: center;              /* Vertically center */
                padding-bottom: 10px;
              }

              form {
                width: 600px;
                background: white;
                padding: 60px;
                padding-top: 30px;
                border-radius: 10px;
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
                padding-bottom: 20px;
                margin-bottom: 60px;
                padding-right: 30px;
              }

   
    table {
        width: 100%;
    }

    table td {
        padding: 10px 8px;
        vertical-align: middle;
    }

     label {
        display: inline-block;
        width: 120px;
        font-weight: 500;
    }

    input[type="text"],
    input[type="date"],
    select {
        width: 100%;
        padding: 6px;
        padding-right: 20px;
        box-sizing: border-box;
    }

    input[type="submit"] {
        margin-top: 10px;
        padding: 8px 20px;
        font-weight: 500;
    }

    legend{
        font-family: 'Merriweather', serif;
    }
  
         </style>
    </head>
    
    <body>
            
        <header class="navbar">
             <div class="left-section">
                <div class="burger-menu" onclick="toggleMenu()">
                   <span></span>
                   <span></span>
                   <span></span>
              
                
                 
                <nav class="nav-links" id="navLinks">
                  <a href="user_home.jsp">Home</a>
                  <a href="BookCatalogProcessing">Book Catalog</a>
                  <a href="MyBorrowingServlet">My Borrowing</a>
                  <a href="#" onclick="confirmLogout(event)">Logout</a>
                </nav>   
            </div>
                </div>
           <div class="center">
                <h1>Whisperwood Library</h1>
            </div>

            <div class="right-section">
                <a href="user_profile.jsp">
                <img src="images/profile.png" alt="Profile" class="profile-icon" >
                </a>
            </div> 
        </header>
        
        <br>
            <h3>Borrowing Information</h3>
            <br><br><br>
 <div class="content">
            <form id="myBorrow" action="MyBorrowingServlet" method="post">
                
                <fieldset>
                  
                   
                   <table>
                        <input type="hidden" name="bookId" value="${book.bookId}">
                       <tr>
                           
                           <td><label for="fname">Full Name:</label></td>
                           <td> <input type="text" id="fname" name="fname" required value="<%= (user != null) ? user.getFullname() : "" %>"></td>
                       </tr>
                       <tr>
                            <td><label for="email">Email:</label></td>
                            <td><input type="text" id="email" name="email" required value="<%= (user != null) ? user.getEmail() : "" %>"></td>
                       </tr>

                       <tr>
                            <td><label for="bookTitle">Book Title:</label></td>
                            <td> <select id="bookTitle" name="bookTitle" required>
    <option value="" disabled ${empty selectedBookId ? 'selected' : ''}>Select a book</option>
    <c:forEach var="book" items="${bookList}">
        <option value="${book.bookId}" 
            <c:if test="${selectedBookId == book.bookId}">selected</c:if>>
            ${book.title} by ${book.author} 
        </option>
    </c:forEach>
</select>

                            </td>
                       </tr>
                       <tr>
                           <td> <label for="borrowDate">Booking Date:</label></td>
                           <td><input type="date" id="borrowDate" name="borrowDate" required><br><br></td>
                       </tr>
                       <tr>
                           <td>  <input type="submit" value="Borrow Book"></td>
                            
                       </tr>
                   </table>
                   

                       
                </fieldset>
            </form>
                            
                          

        </div>
</div>
          <%@ include file="footer.jsp" %>                         
    <script src="js/user_js.js"></script>
    </body>
</html>
