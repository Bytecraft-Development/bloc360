"use client"

import { useState, useEffect } from "react"
import { FaTachometerAlt, FaFileInvoiceDollar, FaChartBar, FaUsers, FaCogs, FaSignOutAlt, FaBars } from "react-icons/fa"
import "../../../pages/features/styles/sidemenu.css"
import logo from "../../../assets/logo_bloc360_menu.png"

const Sidebar = ({ onToggle }) => {
  const [isOpen, setIsOpen] = useState(true) 

  const toggleSidebar = () => {
    const newState = !isOpen
    setIsOpen(newState)
    if (onToggle) {
      onToggle(newState)
    }
  }

  
  useEffect(() => {
    if (onToggle) {
      onToggle(isOpen)
    }
  }, [])

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
              <a href="#dashboard" className="menu-link">
                <FaTachometerAlt className="menu-icon" /> Dashboard
              </a>
            </li>
            <li>
              <a href="/expenses" className="menu-link active">
                <FaFileInvoiceDollar className="menu-icon" /> Cheltuieli
              </a>
            </li>
            <li>
              <a href="#rapoarte" className="menu-link">
                <FaChartBar className="menu-icon" /> Rapoarte
              </a>
            </li>
            <li>
              <a href="#membri" className="menu-link">
                <FaUsers className="menu-icon" /> Membri
              </a>
            </li>
            <hr className="divider-line" />
            <li>
              <a href="#setari" className="menu-link">
                <FaCogs className="menu-icon" /> Setari
              </a>
            </li>
            <li>
              <a href="#logout" className="menu-link">
                <FaSignOutAlt className="menu-icon" /> Logout
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </>
  )
}

export default Sidebar

