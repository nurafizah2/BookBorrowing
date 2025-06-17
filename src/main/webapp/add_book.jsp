<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book</title>
    <link rel="stylesheet" href="css/admin-menu-style.css">
     <link href="https://fonts.googleapis.com/css2?family=Kanit:ital,wght@0,400;1,400;1,700&display=Merriweather&family=swap" rel="stylesheet">
    <style>
        /* Basic Styles */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #d6f3f0;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            /* Prevent scrolling */
        }

        /* Form Styles */
        .form-container {
            margin: 40px auto;
            width: 100%;
            max-width: 900px; /* Set max width for larger screens */
            background-color: #fff5d7;
            padding: 30px;
            border: 2px solid #f2d98d;
            box-sizing: border-box;
            flex-grow: 1;
            overflow-y: auto; /* Ensure form is scrollable if needed */
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
            font-size: 18px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }

        .form-group textarea {
            resize: vertical;
        }

        /* Buttons Styles */
        .button-group {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
        }

        .button-group button {
            padding: 10px 20px;
            font-size: 16px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .borrow-btn {
            background-color: #f9c41a;
            color: #000;
        }

        .cancel-btn {
            background-color: #e74c3c;
            color: #fff;
        }


        /* Responsive Design */
        @media (max-width: 768px) {

            .form-container {
                margin: 20px;
                padding: 20px;
            }

            .button-group button {
                width: 100%;
                margin: 10px 0;
            }
        }
        
        h3{
                text-align: center;
                font-family: 'Merriweather', serif;
                font-weight: bold;
                font-size: 25px;
            }
            
            form-group-file{
               visibility: hidden;
            }
            
            



    </style>
</head>
<body>

   <div class="lms-title">
        <div class="spacer"></div>
  <span class="title-text">Whisperwood Library</span>
  <img src="images/logo4.png" alt="whisperwood_logo" class="logo">
</div>


<div class="wrapper">
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
    <!-- Main Form for Adding Book -->
   
    <div class="form-container">
         <h3>Add Book Form</h3>
         
         
         
         
         
        <form action="AddBookProcessing" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" id="title" name="title" required />
            </div>

            <div class="form-group">
                <label for="author">Author(s):</label>
                <input type="text" id="author" name="author" required />
            </div>

            <div class="form-group">
                <label for="publisher">Publisher:</label>
                <input type="text" id="publisher" name="publisher" required />
            </div>

            <div class="form-group">
                <label for="isbn">ISBN:</label>
                <input type="text" id="isbn" name="isbn" required />
            </div>

            <div class="form-group">
                <label for="genre">Genre:</label>
                <input type="text" id="genre" name="genre" required />
            </div>

            <div class="form-group">
                <label for="year">Year of Publication:</label>
                <input type="number" id="year" name="year" min="1000" max="9999" required />
            </div>

            <div class="form-group">
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" min="1" required />
            </div>

            <div class="form-group">
                <label for="description">Book Description:</label>
                <textarea id="description" name="description" rows="4" cols="50"></textarea>
            </div>

            <div class="form-group">
                <label for="cover_image_url">Book Cover Image URL:</label>
                <input type="text" id="cover_image_url" name="cover_image_url" />
            </div>
   
                  <div class="form-group-file">
    <label for="cover_image_file">Or Book Cover Image (Upload .jpg/.png):</label>
    <input type="file" id="cover_image_file" name="cover_image_file" accept=".jpg,.jpeg,.png" />
</div>

            <div class="button-group">
                <button type="submit" class="borrow-btn">Add Book</button>
                <button type="reset" class="cancel-btn">Cancel</button>
            </div>
        </form>
    </div>
    </div>
            
</div>
            <%@ include file="footer.jsp" %>
    <script>
 
      function confirmLogout(event) {
            event.preventDefault(); // Prevent link from navigating
            if (confirm("Are you sure you want to logout?")) {
                window.location.href = "LogoutServlet"; // Redirect only if confirmed
            }
        }
        
             document.addEventListener("DOMContentLoaded", function () {
          const dropdownBtns = document.querySelectorAll(".dropdown-btn");

          dropdownBtns.forEach(btn => {
            btn.addEventListener("click", function (e) {
              e.preventDefault();
              const submenu = this.nextElementSibling;
              
              submenu.classList.toggle("show");

              const arrow = this.querySelector(".arrow");
              if (arrow) arrow.classList.toggle("open");
            });
          });
        });

    </script>
</body>
</html>