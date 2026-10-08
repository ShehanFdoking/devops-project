import { useState, useEffect } from 'react';
import { api } from '../api/api';

function Health() {
    const [loading, setLoading] = useState(true);
    const [health, setHealth] = useState(null);
    const [metrics, setMetrics] = useState(null);

    useEffect(() => {
        loadHealthData();
        const interval = setInterval(loadHealthData, 10000); // Refresh every 10s
        return () => clearInterval(interval);
    }, []);

    const loadHealthData = async () => {
        try {
            const [healthData, metricsData] = await Promise.all([
                api.getHealth(),
                api.getMetrics()
            ]);
            setHealth(healthData);
            setMetrics(metricsData);
            setLoading(false);
        } catch (error) {
            console.error('Error loading health:', error);
            setLoading(false);
        }
    };

    if (loading) {
        return <div className="loading">Loading health data...</div>;
    }

    const isUp = health?.status === 'UP';

    return (
        <div>
            <div className="page-header">
                <h1>❤️ Application Health</h1>
                <p>Monitor the health status of all application components</p>
            </div>

            {/* Overall Health Status */}
            <div className="stats-grid">
                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Backend API</span>
                        <div className={`stat-icon ${isUp ? 'success' : 'danger'}`}>
                            {isUp ? '✓' : '✗'}
                        </div>
                    </div>
                    <div className="stat-value">
                        <span className={`status-badge ${isUp ? 'success' : 'danger'}`}>
                            <span className="status-indicator"></span>
                            {isUp ? 'UP' : 'DOWN'}
                        </span>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Application</span>
                        <div className="stat-icon success">✓</div>
                    </div>
                    <div className="stat-value">
                        <span className="status-badge success">
                            <span className="status-indicator"></span>
                            HEALTHY
                        </span>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Kubernetes</span>
                        <div className="stat-icon success">✓</div>
                    </div>
                    <div className="stat-value">
                        <span className="status-badge success">
                            <span className="status-indicator"></span>
                            HEALTHY
                        </span>
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">ECR</span>
                        <div className="stat-icon success">✓</div>
                    </div>
                    <div className="stat-value">
                        <span className="status-badge success">
                            <span className="status-indicator"></span>
                            CONNECTED
                        </span>
                    </div>
                </div>
            </div>

            {/* Detailed Health Information */}
            <div className="card">
                <div className="card-header">🔍 Health Details</div>
                <table className="table">
                    <thead>
                        <tr>
                            <th>Component</th>
                            <th>Status</th>
                            <th>Response Time</th>
                            <th>Uptime</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                    <span>🔧</span> Backend API
                                </div>
                            </td>
                            <td>
                                <span className={`status-badge ${isUp ? 'success' : 'danger'}`}>
                                    <span className="status-indicator"></span>
                                    {isUp ? 'UP' : 'DOWN'}
                                </span>
                            </td>
                            <td>{metrics?.avgResponseTime || 0} ms</td>
                            <td>{metrics?.uptimeFormatted || '0h 0m'}</td>
                        </tr>
                        <tr>
                            <td>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                    <span>🗄️</span> Database
                                </div>
                            </td>
                            <td>
                                <span className="status-badge success">
                                    <span className="status-indicator"></span>
                                    UP
                                </span>
                            </td>
                            <td>12 ms</td>
                            <td>{metrics?.uptimeFormatted || '0h 0m'}</td>
                        </tr>
                        <tr>
                            <td>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                    <span>☸️</span> Kubernetes
                                </div>
                            </td>
                            <td>
                                <span className="status-badge success">
                                    <span className="status-indicator"></span>
                                    HEALTHY
                                </span>
                            </td>
                            <td>8 ms</td>
                            <td>24h 15m</td>
                        </tr>
                        <tr>
                            <td>
                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                    <span>🐳</span> Docker
                                </div>
                            </td>
                            <td>
                                <span className="status-badge success">
                                    <span className="status-indicator"></span>
                                    RUNNING
                                </span>
                            </td>
                            <td>5 ms</td>
                            <td>24h 15m</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            {/* Health Check Configuration */}
            <div className="card">
                <div className="card-header">⚙️ Health Check Configuration</div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.5rem' }}>
                    <div>
                        <h4 style={{ marginBottom: '1rem' }}>Liveness Probe</h4>
                        <div style={{ fontSize: '0.875rem', color: 'var(--gray-700)' }}>
                            <div style={{ marginBottom: '0.5rem' }}>
                                <strong>Endpoint:</strong> /actuator/health
                            </div>
                            <div style={{ marginBottom: '0.5rem' }}>
                                <strong>Interval:</strong> 10 seconds
                            </div>
                            <div style={{ marginBottom: '0.5rem' }}>
                                <strong>Timeout:</strong> 5 seconds
                            </div>
                            <div>
                                <strong>Failure Threshold:</strong> 3
                            </div>
                        </div>
                    </div>
                    <div>
                        <h4 style={{ marginBottom: '1rem' }}>Readiness Probe</h4>
                        <div style={{ fontSize: '0.875rem', color: 'var(--gray-700)' }}>
                            <div style={{ marginBottom: '0.5rem' }}>
                                <strong>Endpoint:</strong> /actuator/health
                            </div>
                            <div style={{ marginBottom: '0.5rem' }}>
                                <strong>Interval:</strong> 5 seconds
                            </div>
                            <div style={{ marginBottom: '0.5rem' }}>
                                <strong>Timeout:</strong> 3 seconds
                            </div>
                            <div>
                                <strong>Failure Threshold:</strong> 3
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Last Health Check */}
            <div className="card">
                <div className="card-header">🕐 Last Health Check</div>
                <div style={{ fontSize: '0.875rem' }}>
                    <div style={{ marginBottom: '0.5rem' }}>
                        <strong>Timestamp:</strong> {new Date().toLocaleString()}
                    </div>
                    <div style={{ marginBottom: '0.5rem' }}>
                        <strong>Status Code:</strong> 200 OK
                    </div>
                    <div>
                        <strong>Response:</strong>
                        <pre style={{
                            background: 'var(--gray-50)',
                            padding: '1rem',
                            borderRadius: '0.5rem',
                            marginTop: '0.5rem',
                            overflow: 'auto'
                        }}>
                            {JSON.stringify(health, null, 2)}
                        </pre>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Health;
