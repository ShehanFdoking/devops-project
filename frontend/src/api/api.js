// Use relative URLs in production, absolute in development
const API_BASE_URL = import.meta.env.DEV ? 'http://localhost:8082' : '';

const fetchWithErrorHandling = async (url) => {
    try {
        console.log(`Fetching: ${API_BASE_URL}${url}`);
        const response = await fetch(`${API_BASE_URL}${url}`);
        console.log(`Response status: ${response.status}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log(`Data received:`, data);
        return data;
    } catch (error) {
        console.error(`Fetch error for ${API_BASE_URL}${url}:`, error);
        throw error;
    }
};

export const api = {
    // Application info
    getHello: () => fetchWithErrorHandling(`/api/hello`),
    getStatus: () => fetchWithErrorHandling(`/api/status`),

    // Health
    getHealth: () => fetchWithErrorHandling(`/actuator/health`),

    // Metrics
    getMetrics: () => fetchWithErrorHandling(`/api/metrics`),

    // Deployments
    getDeployments: () => fetchWithErrorHandling(`/api/deployments`),
    getLatestDeployment: () => fetchWithErrorHandling(`/api/deployments/latest`),

    // Services
    getServices: () => fetchWithErrorHandling(`/api/services`),
    getServicesStatus: () => fetchWithErrorHandling(`/api/services/status`),

    // API Info
    getApiEndpoints: () => fetchWithErrorHandling(`/api/info/endpoints`),
    getVersion: () => fetchWithErrorHandling(`/api/info/version`),
    getEnvironment: () => fetchWithErrorHandling(`/api/info/environment`),
};
