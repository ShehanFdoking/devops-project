package com.example.devops.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

import java.io.IOException;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve static resources (CSS, JS, images)
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("classpath:/static/assets/");

        registry.addResourceHandler("/favicon.ico", "/robots.txt")
                .addResourceLocations("classpath:/static/");

        // Serve React app for all non-API routes
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/")
                .resourceChain(true)
                .addResolver(new PathResourceResolver() {
                    @Override
                    protected Resource getResource(String resourcePath, Resource location) throws IOException {
                        Resource requestedResource = location.createRelative(resourcePath);
                        
                        // If file exists and it's not an API route, return it
                        if (requestedResource.exists() && requestedResource.isReadable()) {
                            return requestedResource;
                        }
                        
                        // For client-side routing: return index.html for non-API routes
                        // But DON'T serve index.html for API and actuator endpoints
                        if (!resourcePath.startsWith("api/") && 
                            !resourcePath.startsWith("actuator/") &&
                            !resourcePath.startsWith("welcome")) {
                            Resource indexResource = new ClassPathResource("/static/index.html");
                            if (indexResource.exists()) {
                                return indexResource;
                            }
                        }
                        
                        return null;
                    }
                });
    }
}
