package com.controller;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import java.io.IOException;
import java.io.InputStream;
/**
 *
 * @author USER
 */

public class FirebaseServlet implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
           InputStream serviceAccount = sce.getServletContext()
    .getResourceAsStream("/WEB-INF/serviceAccountKey.json");
            FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .setStorageBucket("library-borrowing-system-2ae79.firebasestorage.app")
                .build();

            FirebaseApp.initializeApp(options);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}
