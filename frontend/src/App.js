import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [lastUpdated, setLastUpdated] = useState(null);

  const fetchEmployees = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Use relative path to let Nginx proxy handle the API calls
      const response = await axios.get('/api/users/');
      setEmployees(response.data);
      setLastUpdated(new Date().toLocaleString());
    } catch (err) {
      setError('Failed to fetch employee data. Please try again.');
      console.error('Error fetching employees:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchEmployees();
    
    // Auto-refresh every 30 seconds
    const interval = setInterval(fetchEmployees, 30000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="App">
      <div className="container">
        <div className="header">
          <h1>Employee Details Dashboard</h1>
        </div>

        {lastUpdated && (
          <div className="status-info">
            <strong>Last Updated:</strong> {lastUpdated}
          </div>
        )}

        <button className="refresh-button" onClick={fetchEmployees}>
          Refresh Data
        </button>

        {error && (
          <div className="error">
            {error}
          </div>
        )}

        {loading ? (
          <div className="loading">Loading employee data...</div>
        ) : (
          <div className="employee-grid">
            {employees.map((employee) => (
              <div key={employee.id} className="employee-card">
                <h3>{employee.name}</h3>
                <div className="employee-info">
                  <strong>Age:</strong> {employee.age}
                </div>
                <div className="employee-info">
                  <strong>Phone:</strong> {employee.phone_number}
                </div>
                <div className="employee-info">
                  <strong>Address:</strong> {employee.home_address}
                </div>
                <div className="employee-info">
                  <strong>Created:</strong> {new Date(employee.created_at).toLocaleDateString()}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default App; 