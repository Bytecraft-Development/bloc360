import React, { useState } from "react";
import Sidebar from "../components/sidemenu";
import "../../../pages/features/styles/expenses.css";

const ExpensesPage = () => {
  const [expenses, setExpenses] = useState([]);
  const [formData, setFormData] = useState({
    date: "",
    supplier: "",
    amount: "",
    paymentType: "",
    category: "",
    details: "",
    document: "",
    recurring: "Nu", // Valoare inițială setată pe "Nu"
    series: "",
  });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleDocumentUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      setFormData({ ...formData, document: file.name });
    }
  };

  const handleAddExpense = () => {
    setExpenses([...expenses, formData]);
    setFormData({
      date: "",
      supplier: "",
      amount: "",
      paymentType: "",
      category: "",
      details: "",
      document: "",
      recurring: "Nu",
      series: "",
    });
  };

  return (
    <div className="expenses-page-container">
      <Sidebar />
      <div className="expenses-page-content">
        <header className="expenses-header">
          <h1>Cheltuieli asociate</h1>
          <button className="expenses-add-button" onClick={handleAddExpense}>
            <span className="add-button-icon">+</span> Adaugă factura
          </button>
        </header>

        <div className="expenses-form">
          <div className="form-group">
            <label htmlFor="date">Data</label>
            <input
              type="date"
              name="date"
              value={formData.date}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="supplier">Furnizor</label>
            <input
              type="text"
              name="supplier"
              value={formData.supplier}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="amount">Suma</label>
            <input
              type="number"
              name="amount"
              value={formData.amount}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="paymentType">Mod repartizare</label>
            <input
              type="text"
              name="paymentType"
              value={formData.paymentType}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="category">Repartizata catre</label>
            <input
              type="text"
              name="category"
              value={formData.category}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="details">Bloc + Scari</label>
            <input
              type="text"
              name="details"
              value={formData.details}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="series">Seria si nr.</label>
            <input
              type="text"
              name="series"
              value={formData.series}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="document">Document</label>
            <input
              type="file"
              onChange={handleDocumentUpload}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="recurring">Recurent</label>
            <select
              name="recurring"
              value={formData.recurring}
              onChange={handleInputChange}
              className="form-input"
            >
              <option value="Da">Da</option>
              <option value="Nu">Nu</option>
            </select>
          </div>

          <button onClick={handleAddExpense} className="form-submit-button">
            Adaugă
          </button>
        </div>

        <div className="expenses-list">
          {expenses.map((expense, index) => (
            <div className="expense-item" key={index}>
              <div className="expense-date">{expense.date}</div>
              <div className="expense-supplier">{expense.supplier}</div>
              <div className="expense-amount">{expense.amount}</div>
              <div className="expense-payment-type">{expense.paymentType}</div>
              <div className="expense-category">{expense.category}</div>
              <div className="expense-details">{expense.details}</div>
              <div className="expense-document">
                <a href="#">{expense.document}</a>
              </div>
              <div className="expense-recurring">
                {expense.recurring === "Da" ? "Da" : "Nu"}
              </div>
              <div className="expense-series">{expense.series}</div>
              <div className="expense-settings">
                <button className="settings-icon">⚙️</button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ExpensesPage;
