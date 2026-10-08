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
@RequestMapping("/api/info")
@CrossOrigin(origins = "*")
public class ApiInfoController {

    @GetMapping("/endpoints")
    public List<Map<String, String>> getApiEndpoints() {
        List<Map<String, String>> endpoints = new ArrayList<>();
        
        endpoints.add(createEndpoint("GET", "/api/hello", "Returns application information", "Public"));
        endpoints.add(createEndpoint("GET", "/api/metrics", "System metrics and performance data", "Public"));
        endpoints.add(createEndpoint("GET", "/api/deployments", "Deployment history", "Public"));
        endpoints.add(createEndpoint("GET", "/api/services", "Running services status", "Public"));
        endpoints.add(createEndpoint("GET", "/api/info/endpoints", "List all API endpoints", "Public"));
        endpoints.add(createEndpoint("GET", "/actuator/health", "Application health check", "Public"));
        endpoints.add(createEndpoint("GET", "/actuator/prometheus", "Prometheus metrics", "Public"));
        
        return endpoints;
    }
    
    @GetMapping("/version")
    public Map<String, String> getVersion() {
        Map<String, String> version = new HashMap<>();
        version.put("version", "2.0");
        version.put("buildDate", "2026-10-08");
        version.put("commitHash", "47fcef8");
        version.put("environment", getEnvironment());
        return version;
    }
    
    @GetMapping("/environment")
    public Map<String, String> getEnvironmentInfo() {
        Map<String, String> env = new HashMap<>();
        env.put("environment", getEnvironment());
        env.put("javaVersion", System.getProperty("java.version"));
        env.put("springBootVersion", "3.2.0");
        env.put("profile", System.getProperty("spring.profiles.active", "default"));
        return env;
    }
    
    private Map<String, String> createEndpoint(String method, String path, String description, String auth) {
        Map<String, String> endpoint = new HashMap<>();
        endpoint.put("method", method);
        endpoint.put("path", path);
        endpoint.put("description", description);
        endpoint.put("authentication", auth);
        return endpoint;
    }
    
    private String getEnvironment() {
        String profile = System.getProperty("spring.profiles.active");
        if (profile != null && profile.contains("prod")) {
            return "production";
        } else if (profile != null && profile.contains("staging")) {
            return "staging";
        }
        return "development";
    }
}
