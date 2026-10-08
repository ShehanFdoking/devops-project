package com.example.devops.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/deployments")
@CrossOrigin(origins = "*")
public class DeploymentController {

    @GetMapping
    public List<Map<String, Object>> getDeployments() {
        List<Map<String, Object>> deployments = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        
        deployments.add(createDeployment("2.0", "success", "2026-10-08 13:04", "Full CI/CD pipeline test"));
        deployments.add(createDeployment("1.0", "success", "2026-10-07 15:30", "Initial production release"));
        deployments.add(createDeployment("0.9", "success", "2026-10-06 10:20", "Pre-production testing"));
        deployments.add(createDeployment("0.8", "failed", "2026-10-05 14:15", "Test deployment failed"));
        deployments.add(createDeployment("0.7", "success", "2026-10-04 09:00", "Beta release"));
        
        return deployments;
    }
    
    @GetMapping("/latest")
    public Map<String, Object> getLatestDeployment() {
        return createDeployment("2.0", "success", "2026-10-08 13:04", "Full CI/CD pipeline test");
    }
    
    private Map<String, Object> createDeployment(String version, String status, String date, String description) {
        Map<String, Object> deployment = new HashMap<>();
        deployment.put("version", version);
        deployment.put("status", status);
        deployment.put("date", date);
        deployment.put("description", description);
        deployment.put("environment", "production");
        deployment.put("duration", Math.round(Math.random() * 300) + 60 + "s");
        return deployment;
    }
}
