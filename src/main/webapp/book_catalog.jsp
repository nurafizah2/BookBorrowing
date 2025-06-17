<%-- 
    Author     : Nurafizah
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <title>Book Borrowing System</title>
       
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/header-footer.css">
<link href="https://fonts.googleapis.com/css2?family=Kanit:ital,wght@0,400;1,400;1,700&display=swap" rel="stylesheet">

        
    <style>
          
        .search-box {
            position: relative;
            padding: 5px;
            
    width: 100%;
    max-width: 400px;
        }
        .search-box input[type="text"] {
            width: 100%;
            padding: 8px 30px 8px 10px; /* leave space on the right for the icon */
            font-size: 16px;
            
        }
       .search-box .search-icon {
            position: absolute;
       
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none; /* so clicking icon focuses input */
            font-size: 18px;
            color: #999;
  
    right: 12px;
   
 
        }
        .search-button {
            margin-left: 10px;
            padding: 8px 20px;
            border: none;
            background-color: #4285f4;
            color: white;
            border-radius: 24px;
            cursor: pointer;
            font-size: 16px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            
        }
        

        .search-button:hover {
            background-color: #357ae8;
        }

       .book-card img {
            
            width: 200px;
            object-fit: cover;
            height: 250px;
            object-fit: cover;
        }
            
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
            
        .book-card {
            height: 400px;
            width: 200px;
            display: flex;
            flex-direction: column;
            border-radius: 8px;
      
        }

        .book-card .card-body {
          flex-grow: 1;
        
          overflow:auto;
         
    padding: 15px;
    overflow: auto;
        }

        .book-card .card-title {
     
          font-weight: 600;
        
          font-size: 1.1rem;
    margin-bottom: 5px;
        }

        .book-card .card-text {
      
        
          margin: 0;
          font-size: 0.95rem;
    color: #333;
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
        
        <div class="container mt-4">
            <div class="search-box mb-4">
                <form action="BookCatalogProcessing" class="d-flex">
               
                    <input type="text"  id="searchInput" name="keyword" placeholder="Search books..." class="form-control" autocomplete="off"/>
  
                    <button type="submit" class="search-button">Search</button>
                </form>
                  
                     
            </div>

            <div class="row">
                <c:forEach var="book" items="${bookList}">
                    <div class="col-md-3 mb-3">
                        <a href="book_details.jsp?bookId=${book.bookId}" style="text-decoration: none; color: inherit;">
                            <div class="card book-card h-100">
                                <img src="${book.bookCoverImage}" class="card-img-top" alt="Book Cover">
                                <div class="card-body">
                                    <h4 class="card-title">${book.title}</h4>
                                    <p class="card-text">Author: ${book.author}</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
<%@ include file="footer.jsp" %>
   

        <script src="js/user_js.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
  const input = document.getElementById("searchInput");
  

  input.addEventListener("input", function () {
    const keyword = this.value.trim();

    if (keyword.length === 0) {
      suggestionBox.innerHTML = "";
      return;
    }

  
  });

  document.addEventListener("click", function (e) {
    if (!input.contains(e.target) && !suggestionBox.contains(e.target)) {
      suggestionBox.innerHTML = "";
    }
  });
});


</script>
    </body>
</html>
