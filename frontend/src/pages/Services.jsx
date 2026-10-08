import { useState, useEffect } from 'react';
import { api } from '../api/api';

function Services() {
    const [loading, setLoading] = useState(true);
    const [services, setServices] = useState([]);

    useEffect(() => {
        loadServices();
        const interval = setInterval(loadServices, 10000);
        return () => clearInterval(interval);
    }, []);

    const loadServices = async () => {
        try {
            const data = await api.getServices();
            setServices(data);
            setLoading(false);
        } catch (error) {
            console.error('Error loading services:', error);
            setLoading(false);
        }
    };

    if (loading) return <div className="loading">Loading services...</div>;

    return (
        <div>
            <div className="page-header">
                <h1>📦 Services</h1>
                <p>Infrastructure and service status</p>
            </div>

            <div className="stats-grid">
                {services.map((service, idx) => (
                    <div key={idx} className="stat-card">
                        <div className="stat-header">
                            <span className="stat-title">{service.name}</span>
                            <div className="stat-icon success">✓</div>
                        </div>
                        <div className="stat-value">
                            <span className="status-badge success">
                                <span className="status-indicator"></span>
                                {service.status}
                            </span>
                        </div>
                        <div className="stat-change">{service.version}</div>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default Services;
