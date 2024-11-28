import React, { useState, useEffect } from "react";
import { userou} from "next/router";
import axios from "axios";

const LoginView: React.FC = () => {
  const [username, setUsername] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [rememberMe, setRememberMe] = useState<boolean>(false);
  const [isPasswordVisible, setIsPasswordVisible] = useState<boolean>(false);
  const router = useRouter(); // Înlocuiește useNavigate cu useRouter

  interface DecodedToken {
    exp: number; 
    iat: number; 
    sub: string; 
  }

  useEffect(() => {
    const loadTokenFromStorage = async () => {
      const storedToken = localStorage.getItem("access_token");
      if (storedToken) {
        const decodedToken: DecodedToken = JSON.parse(atob(storedToken.split(".")[1]));
        const expiry = decodedToken.exp * 1000; // Convert to milliseconds
        if (Date.now() < expiry) {
          router.push("/features/dashboard/dashboard"); 
        } else {
          localStorage.removeItem("access_token");
        }
      }
    };
    loadTokenFromStorage();
  }, [router]);

  const handleLogin = async () => {
    try {
      const response = await axios.post(
        `https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/token`,
        new URLSearchParams({
          client_id: "bloc360token",
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
        router.push("/features/dashboard/dashboard"); // Navighează către dashboard
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
    router.push("/register"); // Navighează către pagina de înregistrare
  };

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Intra in cont</h1>
      <p>Bine ai venit! Alege o metoda de log in:</p>
      <div>
        {/* Add buttons for Google and Facebook login here */}
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
