import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import "../../../pages/features/styles/login.css";
import loginImage from "../../../assets/people.png";
import googleLogo from "../../../assets/google.png";
import facebookLogo from "../../../assets/facebook.png";
import logo from "../../../assets/logo_bloc360_transparent.png";
import { CiLock } from "react-icons/ci";
import { FaEye } from "react-icons/fa";
import { FaEyeSlash } from "react-icons/fa6";
import { SlEnvolope } from "react-icons/sl";
import { MdCheckBoxOutlineBlank } from "react-icons/md"; 
import { IoIosCheckbox } from "react-icons/io"; 




const LoginView = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [isPasswordVisible, setIsPasswordVisible] = useState(false);
  const navigate = useNavigate(); 

  useEffect(() => {
    const loadTokenFromStorage = () => {
      const storedToken = localStorage.getItem("access_token");
      if (storedToken) {
        const decodedToken = JSON.parse(atob(storedToken.split(".")[1]));
        const expiry = decodedToken.exp * 1000; 
        if (Date.now() < expiry) {
          navigate("/dashboard");
        } else {
          localStorage.removeItem("access_token");
        }
      }
    };
    loadTokenFromStorage();
  }, [navigate]);

  const handleLogin = async () => {
    const tokenUrl = process.env.REACT_APP_TOKEN_URL;
      const clientId = process.env.REACT_APP_KEYCLOAK_CLIENT_ID;
    try {
      const response = await axios.post(
        tokenUrl, 
        new URLSearchParams({
          client_id: clientId, 
          username,
          password,
          grant_type: "password",
        }),
        {
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
        }
      );
  
      if (response.status === 200) {
        const { access_token, refresh_token } = response.data;
        localStorage.setItem("access_token", access_token);
        localStorage.setItem("refresh_token", refresh_token);
        navigate("/dashboard");
      }
    } catch (error) {
      console.error("Login failed:", error);
    }
  };

  const handleForgotPassword = () => {
    console.log("Forgot Password");
  };

  const handleRememberMeToggle = () => {
    setRememberMe(!rememberMe);
  };

  const handleCreateAccount = () => {
    navigate("/register"); 
  };

  return (
    <div className="login-container">
      <div className="login-content">
        <div className="login-left">
          <h1>Intra in cont</h1>
          <p className="subheading">Bine ai venit! Alege o metoda de log in:</p>
          <div className="login-buttons">
          <button className="login-btn">
          <img className="btn-icon" src={googleLogo} alt="Google Logo" />
    <span className="btn-text">Google</span>
  </button>
  <button className="login-btn">
  <img className="btn-icon" src={facebookLogo} alt="Facebook Logo" />
    <span className="btn-text">Facebook</span>
  </button>
          </div>
          <div className="divider">
          <hr className="divider-line" />
  <p>sau foloseste email-ul</p>
  <hr className="divider-line" />
          </div>
          <form
            onSubmit={(e) => {
              e.preventDefault();
              handleLogin();
            }}
          >
           <div className="input-container">
  <input
    type="email"
    placeholder="E-mail"
    value={username}
    onChange={(e) => setUsername(e.target.value)}
    required
  />
  <SlEnvolope className="input-icon-email"/> 
</div>
<div className="password-container">
  <CiLock className="input-icon" /> 
  <input
    type={isPasswordVisible ? "text" : "password"}
    placeholder="Parola"
    value={password}
    onChange={(e) => setPassword(e.target.value)}
    required
  />
  <button
    type="button"
    className="toggle-visibility"
    onClick={() => setIsPasswordVisible(!isPasswordVisible)}
  >
    {isPasswordVisible ? <FaEye /> : <FaEyeSlash />} 
  </button>
</div>
<div className="remember-me-container">
  <div className="remember-me">
    <label className="checkbox-label">
      <input
        type="checkbox"
        checked={rememberMe}
        onChange={handleRememberMeToggle} 
        className="checkbox-input"
      />
      {rememberMe ? (
        <IoIosCheckbox className="checkbox-icon checked" />
      ) : (
        <MdCheckBoxOutlineBlank className="checkbox-icon" />
      )}
      Ține minte
    </label>
  </div>

  <button 
    type="button" 
    className="forgot-password" 
    onClick={handleForgotPassword}
  >
    Am uitat parola
  </button>
</div>
            <button type="submit" className="submit-btn">Login</button>
          </form>
          <div className="newAccount">
  <p>
    Nu ai un cont?{" "}
    <span
      onClick={handleCreateAccount}
      className="createAccount"
    >
      Creeaza cont nou
    </span>
  </p>
</div>
        </div>
    
        <div className="login-right">
  <div className="logo-container">
    <img src={logo} alt="Logo" className="login-logo" />
  </div>
  <img src={loginImage} alt="Login illustration" />
</div>
      </div>
    </div>
  );
};

export default LoginView;
