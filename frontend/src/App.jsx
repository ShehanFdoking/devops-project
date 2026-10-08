import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Health from './pages/Health';
import Metrics from './pages/Metrics';
import Deployments from './pages/Deployments';
import Services from './pages/Services';
import ApiExplorer from './pages/ApiExplorer';
import Settings from './pages/Settings';
import './App.css';

function App() {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/health" element={<Health />} />
          <Route path="/metrics" element={<Metrics />} />
          <Route path="/deployments" element={<Deployments />} />
          <Route path="/services" element={<Services />} />
          <Route path="/api" element={<ApiExplorer />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </Layout>
    </Router>
  );
}

export default App;
