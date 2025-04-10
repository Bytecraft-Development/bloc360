import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import LoginView from "./pages/features/auth/login";
import DashboardView from "./pages/features/dashboard/dashboard";
import CreateAssociationPage from "./pages/features/association/createassociation";
import AddBlocksAndStairsPage from "./pages/features/association/add-blocks-and-stairs";
import AddHouseHold from "./pages/features/association/add-household";
import Logout from "./pages/features/auth/logout";
import ExpensesPage from "./pages/features/expenses/expenses";


function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<LoginView />} />
        <Route path="/dashboard" element={<DashboardView />} />
        <Route path="/register" element={<div>Register Page</div>} />
        <Route path="/createAssociation" element={<CreateAssociationPage/>} />
        <Route path="/add-blocks-and-stairs/:associationId" element={<AddBlocksAndStairsPage />} />
        <Route path="/add-household/:associationId" element={<AddHouseHold/>} />
        <Route path="/expenses" element={<ExpensesPage/>} />
        <Route path="/logout" element={<Logout/>} />
        </Routes>
    </Router>
  );
}

export default App;

//redeploy