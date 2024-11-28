import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import config from "../../../config";

const LoginView = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [isPasswordVisible, setIsPasswordVisible] = useState(false);
  const navigate = useNavigate(); // Hook pentru navigare cu react-router-dom

  useEffect(() => {
    const loadTokenFromStorage = () => {
      const storedToken = localStorage.getItem("access_token");
      if (storedToken) {
        const decodedToken = JSON.parse(atob(storedToken.split(".")[1]));
        const expiry = decodedToken.exp * 1000; // Convert to milliseconds
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
    const tokenUrl = config.keycloakTokenUrl; 
    const clientId = config.keycloakClientId;
    console.log(tokenUrl, clientId); 
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
    navigate("/register"); // Navighează către pagina de înregistrare
  };

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Intra in cont</h1>
      <p>Bine ai venit! Alege o metoda de log in:</p>
      <div>
        {/* Butoane pentru login cu Google și Facebook */}
        <button>Google</button>
        <button>Facebook</button>
      </div>
      <div>
        <hr />
        <p>sau foloseste email-ul</p>
        <hr />
      </div>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          handleLogin();
        }}
      >
        <div>
          <input
            type="email"
            placeholder="E-mail"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>
        <div>
          <input
            type={isPasswordVisible ? "text" : "password"}
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
          <button
            type="button"
            onClick={() => setIsPasswordVisible(!isPasswordVisible)}
          >
            {isPasswordVisible ? "Hide" : "Show"}
          </button>
        </div>
        <div>
          <label>
            <input
              type="checkbox"
              checked={rememberMe}
              onChange={handleRememberMeToggle}
            />
            Ține minte
          </label>
          <button type="button" onClick={handleForgotPassword}>
            Am uitat parola
          </button>
        </div>
        <button type="submit">Login</button>
      </form>
      <p>
        Nu ai un cont?{" "}
        <span
          style={{ color: "blue", cursor: "pointer" }}
          onClick={handleCreateAccount}
        >
          Creeaza cont nou
        </span>
      </p>
    </div>
  );
};

export default LoginView;
