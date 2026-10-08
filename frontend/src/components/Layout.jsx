import { NavLink } from 'react-router-dom';

function Layout({ children }) {
    return (
        <div className="app">
            <aside className="sidebar">
                <div className="sidebar-header">
                    <h1>🚀 DevOps Platform</h1>
                </div>
                <nav>
                    <ul className="nav-menu">
                        <li className="nav-item">
                            <NavLink to="/" className="nav-link">
                                <span>🏠</span> Dashboard
                            </NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink to="/health" className="nav-link">
                                <span>❤️</span> Application Health
                            </NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink to="/metrics" className="nav-link">
                                <span>📊</span> System Metrics
                            </NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink to="/deployments" className="nav-link">
                                <span>🚀</span> Deployments
                            </NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink to="/services" className="nav-link">
                                <span>📦</span> Services
                            </NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink to="/api" className="nav-link">
                                <span>📋</span> API Explorer
                            </NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink to="/settings" className="nav-link">
                                <span>⚙️</span> Settings
                            </NavLink>
                        </li>
                    </ul>
                </nav>
            </aside>
            <main className="main-content">
                {children}
            </main>
        </div>
    );
}

export default Layout;
