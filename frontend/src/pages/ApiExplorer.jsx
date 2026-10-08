import { useState, useEffect } from 'react';
import { api } from '../api/api';

function ApiExplorer() {
    const [endpoints, setEndpoints] = useState([]);
    const [response, setResponse] = useState(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        loadEndpoints();
    }, []);

    const loadEndpoints = async () => {
        try {
            const data = await api.getApiEndpoints();
            setEndpoints(data);
        } catch (error) {
            console.error('Error loading endpoints:', error);
        }
    };

    const testEndpoint = async (path) => {
        setLoading(true);
        try {
            const res = await fetch(`http://localhost:8082${path}`);
            const data = await res.json();
            setResponse({ path, status: res.status, data });
        } catch (error) {
            setResponse({ path, error: error.message });
        }
        setLoading(false);
    };

    return (
        <div>
            <div className="page-header">
                <h1>📋 API Explorer</h1>
                <p>Test and explore available API endpoints</p>
            </div>

            <div className="card">
                <div className="card-header">Available Endpoints</div>
                <table className="table">
                    <thead>
                        <tr>
                            <th>Method</th>
                            <th>Path</th>
                            <th>Description</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {endpoints.map((ep, idx) => (
                            <tr key={idx}>
                                <td><span style={{
                                    background: 'var(--primary)',
                                    color: 'white',
                                    padding: '0.25rem 0.5rem',
                                    borderRadius: '0.25rem',
                                    fontSize: '0.75rem'
                                }}>{ep.method}</span></td>
                                <td><code>{ep.path}</code></td>
                                <td>{ep.description}</td>
                                <td>
                                    <button
                                        className="btn btn-primary"
                                        onClick={() => testEndpoint(ep.path)}
                                        disabled={loading}
                                    >
                                        Test
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>

            {response && (
                <div className="card">
                    <div className="card-header">Response</div>
                    <div><strong>Endpoint:</strong> {response.path}</div>
                    {response.status && <div><strong>Status:</strong> {response.status}</div>}
                    <pre style={{
                        background: 'var(--gray-50)',
                        padding: '1rem',
                        borderRadius: '0.5rem',
                        marginTop: '1rem',
                        overflow: 'auto'
                    }}>
                        {JSON.stringify(response.data || response.error, null, 2)}
                    </pre>
                </div>
            )}
        </div>
    );
}

export default ApiExplorer;
