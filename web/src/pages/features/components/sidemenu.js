"use client";
import { Link } from 'react-router-dom';
import { useState, useEffect } from "react";
import { FaTachometerAlt, FaFileInvoiceDollar, FaChartBar, FaUsers, FaCogs, FaSignOutAlt, FaBars } from "react-icons/fa";
import "../../../pages/features/styles/sidemenu.css";
import logo from "../../../assets/logo_bloc360_menu.png";

const Sidebar = ({ onToggle }) => {
  const [isOpen, setIsOpen] = useState(true);

  const toggleSidebar = () => {
    const newState = !isOpen;
    setIsOpen(newState);
    if (onToggle) {
      onToggle(newState);
    }
  };

  
  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth < 990) {
        setIsOpen(false);
        if (onToggle) onToggle(false);
      } else {
        setIsOpen(true);
        if (onToggle) onToggle(true);
      }
    };
    handleResize();
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, [onToggle]);

  return (
    <>
     <button className="hamburger" onClick={toggleSidebar}>
  <FaBars />
</button>
      <div className={`sidebar ${isOpen ? "open" : "closed"}`}>
        <div className="logo">
          <img src={logo || "/placeholder.svg"} alt="Logo" className="logo-img" />
        </div>
        <nav className="menu">
          <ul>
            <li>
              <Link to="/dashboard" className="menu-link">
                <FaTachometerAlt className="menu-icon" /> Dashboard
              </Link>
            </li>
            <li>
              <Link to="/expenses" className="menu-link active">
                <FaFileInvoiceDollar className="menu-icon" /> Cheltuieli
              </Link>
            </li>
            <li>
              <Link href="/rapoarte" className="menu-link">
                <FaChartBar className="menu-icon" /> Rapoarte
              </Link>
            </li>
            <li>
              <Link href="/membri" className="menu-link">
                <FaUsers className="menu-icon" /> Membri
              </Link>
            </li>
            <hr className="divider-line" />
            <li>
              <Link href="/setari" className="menu-link">
                <FaCogs className="menu-icon" /> Setari
              </Link>
            </li>
            <li>
              <Link href="/logout" className="menu-link">
                <FaSignOutAlt className="menu-icon" /> Logout
              </Link>
            </li>
          </ul>
        </nav>
      </div>
    </>
  );
};

export default Sidebar;
