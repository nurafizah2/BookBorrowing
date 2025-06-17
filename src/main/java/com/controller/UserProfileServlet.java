/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller;

import com.dao.UserDAO;
import com.google.cloud.storage.Bucket;
import com.google.firebase.cloud.StorageClient;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author USER
 */
@MultipartConfig
public class UserProfileServlet extends HttpServlet {

 @Override
 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     try {
         com.model.User user = (com.model.User) request.getSession().getAttribute("currentUser");
         
         if (user == null) {
             response.sendRedirect("login.jsp");
             return;
         }
         
         
         
         String email = request.getParameter("email");
         Part filePart = request.getPart("profileImage");
         
         String imageUrl = null;
         
         if (filePart != null && filePart.getSize() > 0) {
             InputStream fileStream = filePart.getInputStream();
             String fileName = UUID.randomUUID().toString() + "_" + filePart.getSubmittedFileName();
             
             // Upload to Firebase
             Bucket bucket = StorageClient.getInstance().bucket();
             bucket.create("profile_pictures/" + fileName, fileStream, filePart.getContentType());
             
             // Get public URL
             imageUrl = "https://firebasestorage.googleapis.com/v0/b/"
                     + bucket.getName() + "/o/profile_pictures%2F" + URLEncoder.encode(fileName, "UTF-8") + "?alt=media";
         }
         
         // Update in DB
         UserDAO dao = new UserDAO();
         dao.updateUserProfile(user.getId(), email, imageUrl);
         
         user.setEmail(email);
         if (imageUrl != null) user.setProfile_picture(imageUrl);
         
         response.sendRedirect("user_profile.jsp?success=true");
     } catch (SQLException ex) {
      
         Logger.getLogger(UserProfileServlet.class.getName()).log(Level.SEVERE, null, ex);
           response.sendRedirect("user_profile.jsp?error=true");
     }
    }
}
