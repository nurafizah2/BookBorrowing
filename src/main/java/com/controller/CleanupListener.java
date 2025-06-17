package com.controller;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;


public class CleanupListener implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        AbandonedConnectionCleanupThread.checkedShutdown();
        System.out.println("MySQL AbandonedConnectionCleanupThread shutdown complete.");
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Nothing to do here
    }
}
