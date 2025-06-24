package com.controller;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author USER
 */

public class FirebaseServlet implements ServletContextListener {
    
    private static final Logger logger = Logger.getLogger(FirebaseServlet.class.getName());
     
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            InputStream serviceAccount = sce.getServletContext()
                .getResourceAsStream("/WEB-INF/serviceAccountKey.json");

            if (serviceAccount == null) {
                throw new IOException("Firebase serviceAccountKey.json not found");
            }
           
            FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .setStorageBucket("library-borrowing-system-2ae79.firebasestorage.app")
                .build();

            FirebaseApp.initializeApp(options);
            logger.info("Firebase has been initialized successfully.");
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Failed to initialize Firebase", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}
