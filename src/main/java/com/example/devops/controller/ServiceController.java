package com.example.devops.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/services")
@CrossOrigin(origins = "*")
public class ServiceController {

    @GetMapping
    public List<Map<String, String>> getServices() {
        List<Map<String, String>> services = new ArrayList<>();
        
        services.add(createService("Backend API", "running", "Spring Boot 3.2.0"));
        services.add(createService("Frontend", "running", "React 18"));
        services.add(createService("Database", "running", "PostgreSQL 15"));
        services.add(createService("Kubernetes", "healthy", "v1.34.1"));
        services.add(createService("Monitoring", "running", "Prometheus + Grafana"));
        
        return services;
    }
    
    @GetMapping("/status")
    public Map<String, Object> getServicesStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("total", 5);
        status.put("running", 5);
        status.put("stopped", 0);
        status.put("healthy", true);
        return status;
    }
    
    private Map<String, String> createService(String name, String status, String version) {
        Map<String, String> service = new HashMap<>();
        service.put("name", name);
        service.put("status", status);
        service.put("version", version);
        service.put("uptime", Math.round(Math.random() * 24) + "h");
        return service;
    }
}
