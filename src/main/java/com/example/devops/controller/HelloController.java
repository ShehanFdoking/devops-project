package com.example.devops.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class HelloController {

    @GetMapping("/hello")
    public Map<String, String> hello() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Hello from DevOps CI/CD Pipeline!");
        response.put("version", "2.0");
        response.put("pipeline", "Full CI/CD with GitHub Actions");
        response.put("status", "All 13 steps completed!");
        return response;
    }
    
    @GetMapping("/status")
    public Map<String, Object> status() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "online");
        response.put("healthy", true);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }
}
