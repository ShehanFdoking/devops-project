const API_BASE_URL = 'http://localhost:8082';

export const api = {
    // Application info
    getHello: () => fetch(`${API_BASE_URL}/api/hello`).then(r => r.json()),
    getStatus: () => fetch(`${API_BASE_URL}/api/status`).then(r => r.json()),

    // Health
    getHealth: () => fetch(`${API_BASE_URL}/actuator/health`).then(r => r.json()),

    // Metrics
    getMetrics: () => fetch(`${API_BASE_URL}/api/metrics`).then(r => r.json()),

    // Deployments
    getDeployments: () => fetch(`${API_BASE_URL}/api/deployments`).then(r => r.json()),
    getLatestDeployment: () => fetch(`${API_BASE_URL}/api/deployments/latest`).then(r => r.json()),

    // Services
    getServices: () => fetch(`${API_BASE_URL}/api/services`).then(r => r.json()),
    getServicesStatus: () => fetch(`${API_BASE_URL}/api/services/status`).then(r => r.json()),

    // API Info
    getApiEndpoints: () => fetch(`${API_BASE_URL}/api/info/endpoints`).then(r => r.json()),
    getVersion: () => fetch(`${API_BASE_URL}/api/info/version`).then(r => r.json()),
    getEnvironment: () => fetch(`${API_BASE_URL}/api/info/environment`).then(r => r.json()),
};
