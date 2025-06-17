<%-- 
    Author     : USER
--%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
    </body>
</html>
