import React, { useState, useEffect } from "react";
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
    recurring: "Nu", 
    series: "",
  });

  const [blocks, setBlocks] = useState([]);
  const [stairs, setStairs] = useState([]);
  const [apartments, setApartments] = useState([]);
  const [selectedType, setSelectedType] = useState("BLOC");
  const [selectedBlock, setSelectedBlock] = useState(null);
  const [selectedStair, setSelectedStair] = useState(null);
  const [selectedItems, setSelectedItems] = useState([]);
  const [selectAll, setSelectAll] = useState(false);

  useEffect(() => {
    const fetchBlocks = async () => {
      try {
        const apiUrl = process.env.REACT_APP_API_URL;
        const response = await fetch(`${apiUrl}/blocks?associationId=1`);
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const data = await response.json();
        setBlocks(data);
      } catch (error) {
        console.error("Error fetching blocks:", error);
      }
    };
    fetchBlocks();
  }, []);

  useEffect(() => {
    if (selectedBlock) {
      const block = blocks.find(b => b.id === parseInt(selectedBlock));
      setStairs(block ? block.stairs : []);
      setSelectedStair(null);
      setApartments([]);
    }
  }, [selectedBlock, blocks]);

  useEffect(() => {
    if (selectedStair) {
      const fetchApartments = async () => {
        try {
          const apiUrl = process.env.REACT_APP_API_URL;
          const response = await fetch(`${apiUrl}/stair?stairId=${selectedStair}`);
          if (!response.ok) {
            throw new Error("HTTP error fetching apartments");
          }
          setApartments(await response.json());
        } catch (error) {
          console.error("Error fetching apartments:", error);
        }
      };
      fetchApartments();
    }
  }, [selectedStair]);

  const handleTypeChange = (e) => {
    setSelectedType(e.target.value);
    setSelectedItems([]);
    setSelectAll(false);
    setSelectedBlock(null); 
    setSelectedStair(null); 
  };

  const handleCheckboxChange = (id) => {
    setSelectedItems(prev =>
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id]
    );
  };

  const handleSelectAll = () => {
    if (selectAll) {
      setSelectedItems([]);
    } else {
      if (selectedType === "BLOC") {
        setSelectedItems(blocks.map(block => block.id));
      } else if (selectedType === "SCARA" && selectedBlock) {
        setSelectedItems(stairs.map(stair => stair.id));
      } else if (selectedType === "APARTAMENT" && selectedStair) {
        setSelectedItems(apartments.map(apartment => apartment.id));
      }
    }
    setSelectAll(!selectAll);
  };

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
      {/* <Sidebar /> */}
      <div className="expenses-page-content">
        <header className="expenses-header">
          <h1>Cheltuieli asociate</h1>
          <button className="expenses-add-button" onClick={handleAddExpense}>
            <span className="add-button-icon">+</span> Adaugă factura
          </button>
        </header>

        <div className="expenses-form">
          <div className="form-group">
            <label htmlFor="category">Repartizată către</label>
            <select name="category" value={selectedType} onChange={handleTypeChange} className="form-input">
              <option value="BLOC">Bloc</option>
              <option value="SCARA">Scară</option>
              <option value="APARTAMENT">Apartament</option>
            </select>
          </div>

          {selectedType === "BLOC" && (
            <div className="form-group">
              <label>Selectează Blocuri</label>
              <button onClick={handleSelectAll}>
                {selectAll ? "Deselectează tot" : "Selectează tot"}
              </button>
              {blocks.map(block => (
                <div key={block.id}>
                  <input type="checkbox" checked={selectedItems.includes(block.id)} onChange={() => handleCheckboxChange(block.id)} /> {block.name}
                </div>
              ))}
            </div>
          )}

          {(selectedType === "SCARA" || selectedType === "APARTAMENT") && (
            <div className="form-group">
              <label>Selectează Bloc</label>
              <select onChange={(e) => setSelectedBlock(e.target.value)} className="form-input">
                <option value="">Selectează blocul</option>
                {blocks.map(block => (
                  <option key={block.id} value={block.id}>{block.name}</option>
                ))}
              </select>
            </div>
          )}

          {selectedType === "SCARA" && selectedBlock && (
            <div className="form-group">
              <label>Selectează Scara</label>
              {stairs.map(stair => (
                <div key={stair.id}>
                  <input type="checkbox" checked={selectedItems.includes(stair.id)} onChange={() => handleCheckboxChange(stair.id)} /> {stair.name}
                </div>
              ))}
            </div>
          )}

          {selectedType === "APARTAMENT" && selectedBlock && (
            <div className="form-group">
              <label>Selectează Scara</label>
              <select onChange={(e) => setSelectedStair(e.target.value)} className="form-input">
                <option value="">Selectează scara</option>
                {stairs.map(stair => (
                  <option key={stair.id} value={stair.id}>{stair.name}</option>
                ))}
              </select>
            </div>
          )}

          {selectedType === "APARTAMENT" && selectedStair && (
            <div className="form-group">
              <label>Selectează Apartamente</label>
              {apartments.map(apartment => (
                <div key={apartment.id}>
                  <input type="checkbox" checked={selectedItems.includes(apartment.id)} onChange={() => handleCheckboxChange(apartment.id)} /> {apartment.apartmentNumber}
                </div>
              ))}
            </div>
          )}

         
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
