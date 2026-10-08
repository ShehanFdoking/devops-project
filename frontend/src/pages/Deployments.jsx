import { useState, useEffect } from 'react';
import { api } from '../api/api';

function Deployments() {
    const [loading, setLoading] = useState(true);
    const [deployments, setDeployments] = useState([]);

    useEffect(() => {
        loadDeployments();
    }, []);

    const loadDeployments = async () => {
        try {
            const data = await api.getDeployments();
            setDeployments(data);
            setLoading(false);
        } catch (error) {
            console.error('Error loading deployments:', error);
            setLoading(false);
        }
    };

    if (loading) return <div className="loading">Loading deployments...</div>;

    return (
        <div>
            <div className="page-header">
                <h1>🚀 Deployments</h1>
                <p>CI/CD pipeline deployment history</p>
            </div>

            <div className="card">
                <div className="card-header">Deployment History</div>
                <table className="table">
                    <thead>
                        <tr>
                            <th>Version</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Duration</th>
                            <th>Environment</th>
                        </tr>
                    </thead>
                    <tbody>
                        {deployments.map((dep, idx) => (
                            <tr key={idx}>
                                <td><strong>v{dep.version}</strong></td>
                                <td>
                                    <span className={`status-badge ${dep.status === 'success' ? 'success' : 'danger'}`}>
                                        <span className="status-indicator"></span>
                                        {dep.status}
                                    </span>
                                </td>
                                <td>{dep.date}</td>
                                <td>{dep.duration}</td>
                                <td>{dep.environment}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}

export default Deployments;
