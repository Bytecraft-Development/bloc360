import { useEffect } from "react";
import { useNavigate } from "react-router-dom";

const Logout = () => {
    const navigate = useNavigate();

    // Keycloak token revocation URL
    const keycloakRevokeUrl = "https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/revoke";

    useEffect(() => {
        // Clear local storage and cookies
        document.cookie.split(";").forEach((c) => {
            document.cookie = c
                .replace(/^ +/, "")
                .replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/");
        });

        const accessToken = localStorage.getItem("access_token");
        const clientId = process.env.REACT_APP_KEYCLOAK_CLIENT_ID;

        if (accessToken) {
            // AJAX request to Keycloak token revocation endpoint
            const params = new URLSearchParams();
            params.append("client_id", clientId);
            params.append("token", accessToken);

            fetch(keycloakRevokeUrl, {
                method: "POST", // POST request for token revocation
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: params.toString(),
                credentials: "include", // include cookies if required
            })
                .then((response) => {
                    if (response.ok) {
                        console.log("Token successfully revoked from Keycloak");
                        localStorage.removeItem("access_token");
                        localStorage.removeItem("refresh_token");
                        // Only redirect within the app after revocation
                        navigate("/");
                    } else {
                        console.error("Error revoking token from Keycloak");
                        // Redirect to homepage within the app even if revocation fails
                        navigate("/");
                    }
                })
                .catch((error) => {
                    console.error("Network error during token revocation:", error);
                    // Redirect to homepage in case of an error
                    navigate("/");
                });
        } else {
            console.warn("No access token found in localStorage");
            // Redirect to homepage if no token is found
            navigate("/");
        }
    }, [navigate]);

    return null; // No UI for the logout process
};

export default Logout;
