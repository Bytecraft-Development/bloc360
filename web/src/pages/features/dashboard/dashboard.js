import React from 'react';
import Sidebar from '../components/sidemenu';

const Dashboard = () => {
  return (
    <div>
      <Sidebar />
      <div className="content">
        <h1>Dashboard</h1>
        <p>Continutul dashboard-ului...</p>
      </div>
    </div>
  );
};



export default Dashboard;