package com.example.devops.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    @ResponseBody
    public Map<String, Object> handleError(HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
        
        response.put("error", true);
        response.put("status", statusCode != null ? statusCode : 500);
        response.put("message", errorMessage != null ? errorMessage : "An error occurred");
        
        if (statusCode != null && statusCode == 404) {
            response.put("message", "Resource not found");
            response.put("suggestion", "Try visiting the root URL (/) or check available endpoints at /api");
            
            Map<String, String> availableEndpoints = new HashMap<>();
            availableEndpoints.put("Home", "/");
            availableEndpoints.put("Welcome Page", "/welcome");
            availableEndpoints.put("API Hello", "/api/hello");
            availableEndpoints.put("API Info", "/api/info");
            availableEndpoints.put("Health Check", "/actuator/health");
            
            response.put("availableEndpoints", availableEndpoints);
        }
        
        return response;
    }
}
