import { useState, useEffect } from 'react';
import { api } from '../api/api';

function Metrics() {
    const [loading, setLoading] = useState(true);
    const [metrics, setMetrics] = useState(null);

    useEffect(() => {
        loadMetrics();
        const interval = setInterval(loadMetrics, 5000);
        return () => clearInterval(interval);
    }, []);

    const loadMetrics = async () => {
        try {
            const data = await api.getMetrics();
            setMetrics(data);
            setLoading(false);
        } catch (error) {
            console.error('Error loading metrics:', error);
            setLoading(false);
        }
    };

    if (loading) return <div className="loading">Loading metrics...</div>;

    return (
        <div>
            <div className="page-header">
                <h1>📊 System Metrics</h1>
                <p>Real-time performance monitoring</p>
            </div>

            <div className="stats-grid">
                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">CPU Usage</span>
                        <div className="stat-icon warning">💻</div>
                    </div>
                    <div className="stat-value">{metrics?.cpuUsagePercent || 0}%</div>
                    <div className="metric-bar">
                        <div className="metric-bar-fill success" style={{ width: `${metrics?.cpuUsagePercent || 0}%` }} />
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Memory Usage</span>
                        <div className="stat-icon warning">🧠</div>
                    </div>
                    <div className="stat-value">{metrics?.memoryUsagePercent || 0}%</div>
                    <div className="stat-change">{metrics?.memoryUsed || 0} MB / {metrics?.memoryTotal || 0} MB</div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Requests/sec</span>
                        <div className="stat-icon primary">📈</div>
                    </div>
                    <div className="stat-value">{metrics?.requestsPerSecond || 0}</div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Response Time</span>
                        <div className="stat-icon success">⚡</div>
                    </div>
                    <div className="stat-value">{metrics?.avgResponseTime || 0} ms</div>
                </div>
            </div>

            <div className="card">
                <div className="card-header">📊 Application Metrics</div>
                <table className="table">
                    <tbody>
                        <tr>
                            <td><strong>Total Requests</strong></td>
                            <td>{metrics?.totalRequests || 0}</td>
                        </tr>
                        <tr>
                            <td><strong>Error Count</strong></td>
                            <td style={{ color: 'var(--danger)' }}>{metrics?.errorCount || 0}</td>
                        </tr>
                        <tr>
                            <td><strong>Uptime</strong></td>
                            <td>{metrics?.uptimeFormatted || '0h 0m'}</td>
                        </tr>
                        <tr>
                            <td><strong>Available Processors</strong></td>
                            <td>{metrics?.availableProcessors || 0}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    );
}

export default Metrics;
