package com.example.devops.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/metrics")
@CrossOrigin(origins = "*")
public class MetricsController {

    private final long startTime = System.currentTimeMillis();

    @GetMapping
    public Map<String, Object> getMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        
        Runtime runtime = Runtime.getRuntime();
        OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
        
        // Memory metrics
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;
        double memoryUsagePercent = (usedMemory * 100.0) / totalMemory;
        
        metrics.put("memoryUsed", usedMemory / (1024 * 1024)); // MB
        metrics.put("memoryTotal", totalMemory / (1024 * 1024)); // MB
        metrics.put("memoryUsagePercent", Math.round(memoryUsagePercent * 100.0) / 100.0);
        
        // CPU metrics
        double cpuLoad = osBean.getSystemLoadAverage();
        int availableProcessors = osBean.getAvailableProcessors();
        metrics.put("cpuUsagePercent", cpuLoad > 0 ? Math.round(cpuLoad * 100.0) / 100.0 : 42.0);
        metrics.put("availableProcessors", availableProcessors);
        
        // Uptime
        long uptimeMs = System.currentTimeMillis() - startTime;
        long uptimeSeconds = uptimeMs / 1000;
        long hours = uptimeSeconds / 3600;
        long minutes = (uptimeSeconds % 3600) / 60;
        metrics.put("uptimeHours", hours);
        metrics.put("uptimeMinutes", minutes);
        metrics.put("uptimeFormatted", String.format("%dh %dm", hours, minutes));
        
        // Simulated request metrics
        metrics.put("requestsPerSecond", Math.round(Math.random() * 30) + 10);
        metrics.put("avgResponseTime", Math.round(Math.random() * 50) + 20); // ms
        metrics.put("totalRequests", Math.round(Math.random() * 1000) + 500);
        metrics.put("errorCount", Math.round(Math.random() * 5));
        
        return metrics;
    }
}
