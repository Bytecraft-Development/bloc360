import React from 'react';
import { Link } from 'react-router-dom'; 
import "../../../pages/features/styles/sidemenu.css";

const Sidebar = () => {
  return (
    <div className="sidebar">
      <div className="logo">
        <img src="logo.png" alt="Logo" className="logo-img" />
      </div>
      <nav className="menu">
        <ul>
          <li><Link to="/dashboard">Dashboard</Link></li>
          <li><Link to="/cheltuieli">Cheltuieli</Link></li>
          <li><Link to="/rapoarte">Rapoarte</Link></li>
          <li><Link to="/membri">Membri</Link></li>
          <li><Link to="/setari">Setari</Link></li>
          <li><Link to="/logout">Logout</Link></li>
        </ul>
      </nav>
    </div>
  );
};

export default Sidebar;