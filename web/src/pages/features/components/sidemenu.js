"use client"

import { Link, useLocation } from "react-router-dom"
import { useState, useEffect } from "react"
import { FaTachometerAlt, FaFileInvoiceDollar, FaChartBar, FaUsers, FaCogs, FaSignOutAlt, FaBars } from "react-icons/fa"
import "../../../pages/features/styles/sidemenu.css"
import logo from "../../../assets/logo_bloc360_menu.png"

const Sidebar = ({ onToggle }) => {
  const [isOpen, setIsOpen] = useState(true)
  const location = useLocation()

  const toggleSidebar = () => {
    const newState = !isOpen
    setIsOpen(newState)
    if (onToggle) {
      onToggle(newState)
    }
  }

  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth < 990) {
        setIsOpen(false)
        if (onToggle) onToggle(false)
      } else {
        setIsOpen(true)
        if (onToggle) onToggle(true)
      }
    }
    handleResize()
    window.addEventListener("resize", handleResize)
    return () => window.removeEventListener("resize", handleResize)
  }, [onToggle])

  return (
    <>
      <button className="hamburger" onClick={toggleSidebar}>
        <FaBars size={16} />
      </button>
      <div className={`sidebar ${isOpen ? "open" : "closed"}`}>
        <div className="logo">
          <img src={logo || "/placeholder.svg"} alt="Logo" className="logo-img" />
        </div>
        <nav className="menu">
          <ul>
            <li>
              <Link to="/dashboard" className={`menu-link ${location.pathname === "/dashboard" ? "active" : ""}`}>
                <FaTachometerAlt className="menu-icon" /> Dashboard
              </Link>
            </li>
            <li>
              <Link to="/expenses" className={`menu-link ${location.pathname === "/expenses" ? "active" : ""}`}>
                <FaFileInvoiceDollar className="menu-icon" /> Cheltuieli
              </Link>
            </li>
            <li>
              <Link to="/rapoarte" className={`menu-link ${location.pathname === "/rapoarte" ? "active" : ""}`}>
                <FaChartBar className="menu-icon" /> Rapoarte
              </Link>
            </li>
            <li>
              <Link to="/membri" className={`menu-link ${location.pathname === "/membri" ? "active" : ""}`}>
                <FaUsers className="menu-icon" /> Membri
              </Link>
            </li>
            <hr className="divider-line" />
            <li>
              <Link to="/setari" className={`menu-link ${location.pathname === "/setari" ? "active" : ""}`}>
                <FaCogs className="menu-icon" /> Setari
              </Link>
            </li>
            <li>
              <Link to="/logout" className={`menu-link ${location.pathname === "/logout" ? "active" : ""}`}>
                <FaSignOutAlt className="menu-icon" /> Logout
              </Link>
            </li>
          </ul>
        </nav>
      </div>
    </>
  )
}

export default Sidebar

