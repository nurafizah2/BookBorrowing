<%-- 
    Document   : book_details
    Created on : May 28, 2025, 3:16:02 PM
    Author     : USER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <%@ page import="com.model.Book, com.dao.BookDAO" %>
<!DOCTYPE html>
<html>
    <head>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Details</title>
     
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/header-footer.css">
<link href="https://fonts.googleapis.com/css2?family=Merriweather&family=Nunito&family=Lilita+One&display=Roboto&display=swap" rel="stylesheet">

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
        
        body {
    display: flex;
    flex-direction: column;
    min-height: 100vh; 
   
}

.container {
    flex: 1; /* This pushes the footer down */
}
        
        html, body {
    height: 100%;
    margin: 0;
    padding: 0;
}



h2,p{
    font-family: Nunito; 
}

h2{
    font-weight: bold;
}


</style>
</head>
    <body>
       
<%
    String bookid = request.getParameter("bookId");

    if (bookid == null || bookid.trim().isEmpty()) {
        out.println("<h3>No book ID provided!</h3>");
        return;
    }

    int bookID = Integer.parseInt(bookid); // safe to parse now

    BookDAO dao = new BookDAO();
    Book book = dao.getBookById(bookID);

    if (book == null) {
        out.println("<h3>Book not found!</h3>");
        return;
    }
%>

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

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-4">
                <img src="<%= book.getBookCoverImage() %>" class="img-fluid" alt="Book Cover">
            </div>
            <div class="col-md-8">
                <h2><%= book.getTitle() %></h2>
                <br>
                <p><strong>Author:</strong> <%= book.getAuthor() %></p>
                <p><strong>Description:</strong> <%= book.getBookDescription() %></p>
                <p><strong>Publisher:</strong> <%= book.getPublisher() %></p>
                <p><strong>Publication Year:</strong> <%= book.getYearOfPublication()%></p>
                <a href="book_catalog.jsp" class="btn btn-secondary mt-3">Back to Catalog</a>
               <a href="MyBorrowingServlet?bookId=<%= book.getBookId() %>"  class="btn btn-secondary mt-3">Borrow</a>
            </div>
        </div>
    </div>
          <%@ include file="footer.jsp" %>                         
    <script src="js/js.js"></script>
</body>
</html>
