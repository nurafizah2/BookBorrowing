<%-- 
    Author     : USER
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Merriweather&family=Tagesschrift&family=Lilita+One&display=Roboto&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/header-footer.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <title>Book Borrowing System</title>

        <style>
            body {
                margin: 0;
                padding: 0;
                min-height: 100vh;
                background-image: url('images/homepageimage.jpg');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
            }

            .content-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                background-color: rgba(255, 255, 255, 0.8); 
                width: 90%;
                max-width: 500px;
                margin: 80px auto 0 auto;
                margin-bottom: 30px;
                padding: 30px 20px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
                animation: fadeIn 1.2s ease-in-out;
            }

            .notification-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%; 
                object-fit: cover;
            }

            .logo {
                width: 280px;
                height: auto;
                margin-bottom: 10px;
                display: block;
           }

            .welcome-text {
                font-size: 1.8rem;
                font-weight: 300;
                color: #444;
                margin: 0;
                letter-spacing: 1px;
                font-family: 'Tagesschrift', serif;
                word-break: break-word;
                max-width: 100%;
            }

            .library-name {
                word-break: normal;
                font-size: 2.2rem;
                font-weight: 900;
                color: #2c3e50;
                margin-top: 10px;
                letter-spacing: 2px;
                font-family: 'Merriweather', italic;
                max-width: 100%;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .search-link {
                color: #2c3e50;
                text-decoration: none;
                font-weight: bold;
                font-size: 1.2rem;
                position: relative;
            }

            .search-link::after {
                content: "";
                position: absolute;
                left: 0;
                bottom: -2px;
                width: 100%;
                height: 2px;
                background-color: #2c3e50;
                transform: scaleX(0);
                transform-origin: right;
                transition: transform 0.3s ease;
            }

            .search-link:hover::after {
                transform: scaleX(1);
                transform-origin: left;
            }

            .submenu {
                display: none;
            }
            
            .submenu.show {
                display: block;
            }

            .right-section {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-right: 20px;
            }

            .notification-wrapper {
                position: relative;
            }

            .notification-dropdown {
                display: none;
                position: absolute;
                top: 60px;
                right: 20px;
                width: 320px;
                max-height: 400px;
                overflow-y: auto;
                background: rgba(255, 255, 255, 0.85);
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                padding: 15px 20px;
                z-index: 1000;
                animation: fadeSlide 0.3s ease;
                border: 1px solid rgba(200, 200, 200, 0.3);
            }

            .notification-dropdown h5 {
                margin-top: 0;
                font-size: 1.1rem;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 12px;
                border-bottom: 1px solid #ddd;
                padding-bottom: 5px;
            }

            .notif-item {
                background: #f9f9f9;
                padding: 10px 12px;
                border-radius: 10px;
                margin-bottom: 10px;
                transition: background 0.3s ease;
            }

            .notif-item:hover {
                background: #eef2f7;
            }

            .notif-item.unread {
                border-left: 4px solid #007bff;
                background: #eaf3ff;
            }

            .notif-item a {
                color: #2c3e50;
                text-decoration: none;
                font-weight: 500;
            }

            .notif-item a:hover {
                text-decoration: underline;
            }

            .notif-item small {
                color: #666;
                font-size: 0.8rem;
                display: block;
                margin-top: 5px;
            }

            @keyframes fadeSlide {
              from {
                opacity: 0;
                transform: translateY(-10px);
              }
              to {
                opacity: 1;
                transform: translateY(0);
              }
            }
            
            .notif-bell {
                cursor: pointer;
                font-size: 24px;
                position: relative; 
            }

            .notif-count {
                position: absolute;
                top: -6px;
                right: -10px;
                background: red;
                color: white;
                border-radius: 50%;
                font-size: 12px;
                padding: 2px 6px;
            }
            
            #notificationDropdown {
                display: none;
                position: absolute;
                top: 30px; 
                right: 0;
                background-color: white;
                border: 1px solid #ccc;
                width: 250px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                z-index: 1000;
            }

            #notificationDropdown.show {
                display: block;
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

            <div class="right-section">
                <div class="notification-wrapper">
                    <span id="notificationBell" class="notif-bell">
                        <i class="fas fa-bell"></i>

                        <c:if test="${not empty notifications}">
                            <span id="notifCount" class="notif-count">
                                ${fn:length(notifications)}
                            </span>
                        </c:if>
                    </span>
                </div>

                <a href="user_profile.jsp">
                    <img src="images/profile.png" alt="Profile" class="profile-icon">
                </a>
            </div>
            
            

            <!-- Notification Dropdown Box -->
            <c:if test="${not empty notifications}">
                <div id="notificationDropdown" class="notification-dropdown">
                    <h5>Notifications</h5>
                    <c:forEach var="note" items="${notifications}">
                        <div class="notif-item ${note.isRead ? '' : 'unread'}">
                            <c:if test="${!note.isRead}">
                              <strong>[NEW]</strong>
                            </c:if>

                            <a href="NotificationHandler?id=${note.id}">
                              ${note.message}
                            </a><br>

                            <small>
                              <i class="fas fa-book"></i> <strong>${note.bookTitle}</strong><br>
                              <i class="fas fa-pen-nib"></i> by ${note.authorName}<br>
                              <i class="fas fa-clock"></i> ${note.timeStamp}
                            </small>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
    </header>
        
        <%
    String requestSuccess = request.getParameter("request");
    if ("success".equals(requestSuccess)) {
%>
    <div id="borrowSuccessAlert" class="alert alert-success alert-dismissible fade show" role="alert">
        Your borrow request has been sent. We will notify you soon.
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<%
    }
%>

 
    <div class="content-container">
        <h1 class="welcome-text">Welcome to</h1>
        <h1 class="library-name">Whisperwood Library</h1>
        <img src="images/logo3.png" alt="whisperwood_logo" class="logo" ><br>
        <a href="BookCatalogProcessing" class="search-link">Search book here</a>
    </div>
      
    <%@ include file="footer.jsp" %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const bell = document.getElementById("notificationBell");
            const dropdown = document.getElementById("notificationDropdown");

            if (bell && dropdown) {
                bell.addEventListener("click", function (e) {
                    e.stopPropagation();
                    dropdown.classList.toggle("show");
                });

                document.addEventListener("click", function (e) {
                    if (!dropdown.contains(e.target) && !bell.contains(e.target)) {
                        dropdown.classList.remove("show");
                    }
                });
            }
        });
        
          window.addEventListener("DOMContentLoaded", function () {
    setTimeout(function () {
      const alert = document.getElementById("borrowSuccessAlert");
      if (alert) {
        alert.classList.remove("show");
        alert.classList.add("fade");
      setTimeout(() => {
          alert.remove();
        }, 500);
      }
    }, 3000); // Wait 4 seconds before starting to fade
  });
    </script>
    <script src="js/user_js.js"></script>
    </body>
</html>
