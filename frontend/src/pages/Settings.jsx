import { useState, useEffect } from 'react';
import { api } from '../api/api';

function Settings() {
    const [env, setEnv] = useState(null);

    useEffect(() => {
        loadEnvironment();
    }, []);

    const loadEnvironment = async () => {
        try {
            const data = await api.getEnvironment();
            setEnv(data);
        } catch (error) {
            console.error('Error loading environment:', error);
        }
    };

    return (
        <div>
            <div className="page-header">
                <h1>⚙️ Settings</h1>
                <p>Application configuration and settings</p>
            </div>

            <div className="card">
                <div className="card-header">Application</div>
                <table className="table">
                    <tbody>
                        <tr>
                            <td><strong>Application Name</strong></td>
                            <td>DevOps Platform</td>
                        </tr>
                        <tr>
                            <td><strong>Environment</strong></td>
                            <td>{env?.environment || 'development'}</td>
                        </tr>
                        <tr>
                            <td><strong>Version</strong></td>
                            <td>v2.0</td>
                        </tr>
                        <tr>
                            <td><strong>Backend API URL</strong></td>
                            <td>http://localhost:8082</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div className="card">
                <div className="card-header">System Information</div>
                <table className="table">
                    <tbody>
                        <tr>
                            <td><strong>Java Version</strong></td>
                            <td>{env?.javaVersion || 'N/A'}</td>
                        </tr>
                        <tr>
                            <td><strong>Spring Boot Version</strong></td>
                            <td>{env?.springBootVersion || 'N/A'}</td>
                        </tr>
                        <tr>
                            <td><strong>Profile</strong></td>
                            <td>{env?.profile || 'default'}</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div className="card">
                <div className="card-header">Monitoring</div>
                <table className="table">
                    <tbody>
                        <tr>
                            <td><strong>Auto Refresh</strong></td>
                            <td>✓ Enabled</td>
                        </tr>
                        <tr>
                            <td><strong>Refresh Interval</strong></td>
                            <td>30 seconds</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    );
}

export default Settings;
