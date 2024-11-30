import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import LoginView from "./pages/features/auth/login";
import DashboardView from "./pages/features/dashboard/dashboard";
import CreateAssociationPage from "./pages/features/association/createassociation";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LoginView />} />
        <Route path="/dashboard" element={<DashboardView />} />
        <Route path="/register" element={<div>Register Page</div>} />
        <Route path="/createAssociation" element={<CreateAssociationPage/>} />
      </Routes>
    </Router>
  );
}

export default App;