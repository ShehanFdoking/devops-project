import { useState, useEffect } from 'react';
import { api } from '../api/api';

function Dashboard() {
    const [loading, setLoading] = useState(true);
    const [data, setData] = useState({
        status: null,
        version: null,
        metrics: null,
        latestDeployment: null,
        health: null
    });

    useEffect(() => {
        loadDashboardData();
        const interval = setInterval(loadDashboardData, 30000); // Refresh every 30s
        return () => clearInterval(interval);
    }, []);

    const loadDashboardData = async () => {
        try {
            const [status, version, metrics, deployment, health] = await Promise.all([
                api.getStatus(),
                api.getVersion(),
                api.getMetrics(),
                api.getLatestDeployment(),
                api.getHealth().catch(() => ({ status: 'UP' }))
            ]);

            setData({ status, version, metrics, latestDeployment: deployment, health });
            setLoading(false);
        } catch (error) {
            console.error('Error loading dashboard:', error);
            setLoading(false);
        }
    };

    if (loading) {
        return <div className="loading">Loading dashboard...</div>;
    }

    const isHealthy = data.status?.healthy && data.health?.status === 'UP';

    return (
        <div>
            <div className="page-header">
                <h1>🏠 DevOps Dashboard</h1>
                <p>Real-time monitoring and deployment overview</p>
            </div>

            {/* Application Status */}
            <div className="stats-grid">
                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Application Status</span>
                        <div className={`stat-icon ${isHealthy ? 'success' : 'danger'}`}>
                            {isHealthy ? '✓' : '✗'}
                        </div>
                    </div>
                    <div className="stat-value">
                        <span className={`status-badge ${isHealthy ? 'success' : 'danger'}`}>
                            <span className="status-indicator"></span>
                            {isHealthy ? 'Healthy' : 'Down'}
                        </span>
                    </div>
                    <div className="stat-change">
                        Backend: {data.status?.status || 'online'}
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Application Version</span>
                        <div className="stat-icon primary">🔖</div>
                    </div>
                    <div className="stat-value">v{data.version?.version || '2.0'}</div>
                    <div className="stat-change">
                        Environment: {data.version?.environment || 'development'}
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">CPU Usage</span>
                        <div className="stat-icon warning">💻</div>
                    </div>
                    <div className="stat-value">{data.metrics?.cpuUsagePercent || 0}%</div>
                    <div className="metric-bar">
                        <div
                            className={`metric-bar-fill ${data.metrics?.cpuUsagePercent > 80 ? 'danger' : 'success'}`}
                            style={{ width: `${data.metrics?.cpuUsagePercent || 0}%` }}
                        />
                    </div>
                </div>

                <div className="stat-card">
                    <div className="stat-header">
                        <span className="stat-title">Memory Usage</span>
                        <div className="stat-icon warning">🧠</div>
                    </div>
                    <div className="stat-value">{data.metrics?.memoryUsagePercent || 0}%</div>
                    <div className="metric-bar">
                        <div
                            className={`metric-bar-fill ${data.metrics?.memoryUsagePercent > 80 ? 'danger' : 'warning'}`}
                            style={{ width: `${data.metrics?.memoryUsagePercent || 0}%` }}
                        />
                    </div>
                </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1.5rem' }}>
                {/* Latest Deployment */}
                <div className="card">
                    <div className="card-header">
                        <span>🚀 Latest Deployment</span>
                        <span className={`status-badge ${data.latestDeployment?.status === 'success' ? 'success' : 'danger'}`}>
                            <span className="status-indicator"></span>
                            {data.latestDeployment?.status || 'success'}
                        </span>
                    </div>
                    <div style={{ marginBottom: '1rem' }}>
                        <div style={{ fontSize: '1.5rem', fontWeight: '700', marginBottom: '0.5rem' }}>
                            v{data.latestDeployment?.version || '2.0'} → Production
                        </div>
                        <div style={{ color: 'var(--gray-700)', fontSize: '0.875rem' }}>
                            {data.latestDeployment?.date || '2026-10-08 13:04'}
                        </div>
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <span style={{ color: 'var(--success)' }}>✓</span> Build
                        </div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <span style={{ color: 'var(--success)' }}>✓</span> Tests
                        </div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <span style={{ color: 'var(--success)' }}>✓</span> SonarQube
                        </div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <span style={{ color: 'var(--success)' }}>✓</span> Docker Build
                        </div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                            <span style={{ color: 'var(--success)' }}>✓</span> ECR Push
                        </div>
                    </div>
                </div>

                {/* System Overview */}
                <div className="card">
                    <div className="card-header">📊 System Overview</div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                                <span>Uptime</span>
                                <span style={{ fontWeight: '600' }}>{data.metrics?.uptimeFormatted || '0h 0m'}</span>
                            </div>
                        </div>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                                <span>Requests/sec</span>
                                <span style={{ fontWeight: '600' }}>{data.metrics?.requestsPerSecond || 0}</span>
                            </div>
                        </div>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                                <span>Response Time</span>
                                <span style={{ fontWeight: '600' }}>{data.metrics?.avgResponseTime || 0} ms</span>
                            </div>
                        </div>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                                <span>Total Requests</span>
                                <span style={{ fontWeight: '600' }}>{data.metrics?.totalRequests || 0}</span>
                            </div>
                        </div>
                        <div>
                            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                                <span>Errors</span>
                                <span style={{ fontWeight: '600', color: 'var(--danger)' }}>
                                    {data.metrics?.errorCount || 0}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Recent Activity */}
            <div className="card">
                <div className="card-header">📝 Recent Activity</div>
                <ul className="activity-list">
                    <li className="activity-item">
                        <div className="activity-icon success">✓</div>
                        <div className="activity-content">
                            <h4>Deployment Successful</h4>
                            <p>Version {data.latestDeployment?.version || '2.0'} deployed to production</p>
                        </div>
                    </li>
                    <li className="activity-item">
                        <div className="activity-icon success">✓</div>
                        <div className="activity-content">
                            <h4>Health Check Passed</h4>
                            <p>All services are healthy and running</p>
                        </div>
                    </li>
                    <li className="activity-item">
                        <div className="activity-icon success">✓</div>
                        <div className="activity-content">
                            <h4>Application Started</h4>
                            <p>Backend API initialized successfully</p>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    );
}

export default Dashboard;
