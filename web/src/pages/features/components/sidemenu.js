import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { FaTachometerAlt, FaFileInvoiceDollar, FaChartBar, FaUsers, FaCogs, FaSignOutAlt, FaBars } from "react-icons/fa";
import "../../../pages/features/styles/sidemenu.css";
import logo from "../../../assets/logo_bloc360_menu.png";

const Sidebar = () => {
  const [isOpen, setIsOpen] = useState(false); 

  const toggleSidebar = () => {
    setIsOpen(!isOpen);
  };

  return (
    <div className={`sidebar ${isOpen ? "open" : ""}`}>
      <div className="logo">
        <img src={logo} alt="Logo" className="logo-img" />
      </div>
      <button className="hamburger" onClick={toggleSidebar}>
        <FaBars />
      </button>
      <nav className="menu">
        <ul>
          <li>
            <Link to="/dashboard">
              <FaTachometerAlt className="menu-icon" /> Dashboard
            </Link>
          </li>
          <li>
            <Link to="/cheltuieli">
              <FaFileInvoiceDollar className="menu-icon" /> Cheltuieli
            </Link>
          </li>
          <li>
            <Link to="/rapoarte">
              <FaChartBar className="menu-icon" /> Rapoarte
            </Link>
          </li>
          <li>
            <Link to="/membri">
              <FaUsers className="menu-icon" /> Membri
            </Link>
          </li>
          <hr className="divider-line" />
          <li>
            <Link to="/setari">
              <FaCogs className="menu-icon" /> Setari
            </Link>
          </li>
          <li>
            <Link to="/logout">
              <FaSignOutAlt className="menu-icon" /> Logout
            </Link>
          </li>
        </ul>
      </nav>
    </div>
  );
};

export default Sidebar;
