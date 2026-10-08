package com.example.devops.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class RootController {

    @GetMapping("/")
    @ResponseBody
    public Map<String, Object> root() {
        Map<String, Object> response = new HashMap<>();
        response.put("application", "DevOps Spring Boot Application");
        response.put("version", "2.0.0");
        response.put("status", "running");
        response.put("description", "Full-stack DevOps application with CI/CD pipeline");
        
        Map<String, String> endpoints = new HashMap<>();
        endpoints.put("API Base", "/api");
        endpoints.put("Hello", "/api/hello");
        endpoints.put("Status", "/api/status");
        endpoints.put("Health Check", "/actuator/health");
        endpoints.put("Metrics", "/actuator/metrics");
        endpoints.put("Prometheus", "/actuator/prometheus");
        endpoints.put("API Info", "/api/info");
        endpoints.put("Services", "/api/services");
        endpoints.put("Deployments", "/api/deployments");
        endpoints.put("System Metrics", "/api/metrics/system");
        
        response.put("endpoints", endpoints);
        
        Map<String, String> documentation = new HashMap<>();
        documentation.put("GitHub", "https://github.com/ShehanFdoking/devops-project");
        documentation.put("README", "See repository README.md for full documentation");
        
        response.put("documentation", documentation);
        
        return response;
    }
    
    @GetMapping("/welcome")
    @ResponseBody
    public String welcome() {
        return """
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>DevOps Spring Boot Application</title>
                    <style>
                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }
                        body {
                            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            min-height: 100vh;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            padding: 20px;
                        }
                        .container {
                            background: white;
                            border-radius: 20px;
                            padding: 60px 40px;
                            max-width: 800px;
                            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                            text-align: center;
                        }
                        h1 {
                            color: #667eea;
                            font-size: 3rem;
                            margin-bottom: 20px;
                            font-weight: 700;
                        }
                        .status {
                            display: inline-block;
                            background: #10b981;
                            color: white;
                            padding: 8px 20px;
                            border-radius: 50px;
                            font-weight: 600;
                            margin-bottom: 30px;
                        }
                        .description {
                            color: #64748b;
                            font-size: 1.2rem;
                            margin-bottom: 40px;
                            line-height: 1.6;
                        }
                        .endpoints {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                            gap: 15px;
                            margin-bottom: 40px;
                        }
                        .endpoint {
                            background: #f8fafc;
                            padding: 15px;
                            border-radius: 10px;
                            text-decoration: none;
                            color: #475569;
                            transition: all 0.3s;
                            border: 2px solid transparent;
                        }
                        .endpoint:hover {
                            background: #667eea;
                            color: white;
                            transform: translateY(-2px);
                            border-color: #667eea;
                        }
                        .endpoint strong {
                            display: block;
                            margin-bottom: 5px;
                            font-size: 0.9rem;
                        }
                        .endpoint code {
                            font-size: 0.85rem;
                            opacity: 0.8;
                        }
                        .features {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                            gap: 20px;
                            margin-top: 40px;
                        }
                        .feature {
                            padding: 20px;
                            background: #f1f5f9;
                            border-radius: 10px;
                        }
                        .feature-icon {
                            font-size: 2rem;
                            margin-bottom: 10px;
                        }
                        .feature-title {
                            font-weight: 600;
                            color: #334155;
                            margin-bottom: 5px;
                        }
                        .footer {
                            margin-top: 40px;
                            padding-top: 30px;
                            border-top: 2px solid #e2e8f0;
                            color: #94a3b8;
                            font-size: 0.9rem;
                        }
                        .footer a {
                            color: #667eea;
                            text-decoration: none;
                            font-weight: 600;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>🚀 DevOps Application</h1>
                        <div class="status">✅ Running</div>
                        <p class="description">
                            Full-stack Spring Boot application with React frontend,<br>
                            featuring CI/CD pipeline, Docker containerization, and Kubernetes deployment.
                        </p>
                        
                        <h2 style="margin-bottom: 20px; color: #334155;">📍 Available Endpoints</h2>
                        <div class="endpoints">
                            <a href="/api/hello" class="endpoint">
                                <strong>Hello</strong>
                                <code>/api/hello</code>
                            </a>
                            <a href="/api/info" class="endpoint">
                                <strong>API Info</strong>
                                <code>/api/info</code>
                            </a>
                            <a href="/api/services" class="endpoint">
                                <strong>Services</strong>
                                <code>/api/services</code>
                            </a>
                            <a href="/api/deployments" class="endpoint">
                                <strong>Deployments</strong>
                                <code>/api/deployments</code>
                            </a>
                            <a href="/actuator/health" class="endpoint">
                                <strong>Health</strong>
                                <code>/actuator/health</code>
                            </a>
                            <a href="/actuator/metrics" class="endpoint">
                                <strong>Metrics</strong>
                                <code>/actuator/metrics</code>
                            </a>
                        </div>
                        
                        <div class="features">
                            <div class="feature">
                                <div class="feature-icon">🐳</div>
                                <div class="feature-title">Docker</div>
                            </div>
                            <div class="feature">
                                <div class="feature-icon">☸️</div>
                                <div class="feature-title">Kubernetes</div>
                            </div>
                            <div class="feature">
                                <div class="feature-icon">⚡</div>
                                <div class="feature-title">CI/CD</div>
                            </div>
                            <div class="feature">
                                <div class="feature-icon">📊</div>
                                <div class="feature-title">Monitoring</div>
                            </div>
                        </div>
                        
                        <div class="footer">
                            <p>Built with Spring Boot 3.2.0 & React 19</p>
                            <p><a href="https://github.com/ShehanFdoking/devops-project" target="_blank">View on GitHub</a></p>
                        </div>
                    </div>
                </body>
                </html>
                """;
    }
}
