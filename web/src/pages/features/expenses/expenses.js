import React, { useState, useEffect } from "react";
import "../../../pages/features/styles/expenses.css";

const ExpensesPage = () => {
 
  const [formData, setFormData] = useState({
    provider: "",
    serialNumber: "",
    amount: "",
    consumptionType: 0, 
    documentDate: "",
    description: "",
    reference: "",
    repeatable: false,
  });

  const [expenses, setExpenses] = useState([]);

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
    const { name, value, type, checked } = e.target;
    setFormData({
      ...formData,
      [name]: type === "checkbox" ? checked : value,
    });
  };

  const handleAddExpense = async () => {
    const apiUrl = process.env.REACT_APP_API_URL;
    let householdIds = [];

    if (selectedType === "BLOC") {
      if (selectedItems.length === 0) {
        console.error("Niciun bloc selectat!");
        return;
      }
      
      const query = selectedItems.map(id => `blockIds=${id}`).join('&');
      try {
        const response = await fetch(`${apiUrl}/householdsByBlock?${query}`);
        if (!response.ok) {
          throw new Error("Eroare la preluarea household-urilor de la blocuri");
        }
        const households = await response.json();
        householdIds = households.map(h => h.id);
      } catch (error) {
        console.error("Eroare fetching households by block:", error);
        return;
      }
    } else if (selectedType === "SCARA") {
      if (selectedItems.length === 0) {
        console.error("Nicio scară selectată!");
        return;
      }
      try {
        const fetchHouseholdsForStair = async (stairId) => {
          const response = await fetch(`${apiUrl}/stair?stairId=${stairId}`);
          if (!response.ok) {
            throw new Error(`Eroare la preluarea household-urilor pentru scara ${stairId}`);
          }
          return await response.json();
        };

        const results = await Promise.all(
          selectedItems.map(stairId => fetchHouseholdsForStair(stairId))
        );
        householdIds = results.flat().map(h => h.id);
      } catch (error) {
        console.error("Eroare la preluarea household-urilor pentru scările selectate:", error);
        return;
      }
    } else if (selectedType === "APARTAMENT") {
      if (selectedItems.length === 0) {
        console.error("Niciun apartament selectat!");
        return;
      }
      householdIds = selectedItems;
    }

    if (householdIds.length === 0) {
      console.error("Lista householdIds este goală!");
      return;
    }

   
    const houseHoldList = householdIds.map(id => ({ id }));

   
    const expenseData = {
      provider: formData.provider,
      serialNumber: formData.serialNumber,
      amount: parseFloat(formData.amount),
      consumptionType: formData.consumptionType, 
      documentDate: formData.documentDate,
      description: formData.description,
      reference: formData.reference,
      repeatable: formData.repeatable,
      houseHoldList: houseHoldList,
    };

    console.log("JSON trimis:", JSON.stringify(expenseData, null, 2));

    try {
      const response = await fetch(`${apiUrl}/createExpense`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(expenseData),
      });

      if (!response.ok) {
        throw new Error("Eroare la trimiterea cheltuielii");
      }

      const newExpense = await response.json();
      setExpenses([...expenses, newExpense]);


      setFormData({
        provider: "",
        serialNumber: "",
        amount: "",
        consumptionType: 0,
        documentDate: "",
        description: "",
        reference: "",
        repeatable: false,
      });
      setSelectedItems([]);
    } catch (error) {
      console.error("Eroare la adăugarea cheltuielii:", error);
    }
  };

  return (
    <div className="expenses-page-container">
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
                  <input
                    type="checkbox"
                    checked={selectedItems.includes(block.id)}
                    onChange={() => handleCheckboxChange(block.id)}
                  />{" "}
                  {block.name}
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
                  <option key={block.id} value={block.id}>
                    {block.name}
                  </option>
                ))}
              </select>
            </div>
          )}

          {selectedType === "SCARA" && selectedBlock && (
            <div className="form-group">
              <label>Selectează Scara</label>
              {stairs.map(stair => (
                <div key={stair.id}>
                  <input
                    type="checkbox"
                    checked={selectedItems.includes(stair.id)}
                    onChange={() => handleCheckboxChange(stair.id)}
                  />{" "}
                  {stair.name}
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
                  <option key={stair.id} value={stair.id}>
                    {stair.name}
                  </option>
                ))}
              </select>
            </div>
          )}

          {selectedType === "APARTAMENT" && selectedStair && (
            <div className="form-group">
              <label>Selectează Apartamente</label>
              {apartments.map(apartment => (
                <div key={apartment.id}>
                  <input
                    type="checkbox"
                    checked={selectedItems.includes(apartment.id)}
                    onChange={() => handleCheckboxChange(apartment.id)}
                  />{" "}
                  {apartment.apartmentNumber}
                </div>
              ))}
            </div>
          )}

       
          <div className="form-group">
            <label>Furnizor</label>
            <input
              type="text"
              name="provider"
              value={formData.provider}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label>Serial Number</label>
            <input
              type="text"
              name="serialNumber"
              value={formData.serialNumber}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label>Suma</label>
            <input
              type="number"
              step="0.01"
              name="amount"
              value={formData.amount}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label>Tip consum</label>
            <select
              name="consumptionType"
              value={formData.consumptionType}
              onChange={(e) =>
                setFormData({ ...formData, consumptionType: parseInt(e.target.value, 10) })
              }
              className="form-input"
            >
              <option value={0}>Electricitate</option>
              <option value={1}>Încălzire</option>
              <option value={2}>Apă rece</option>
              <option value={3}>Apă caldă</option>
            </select>
          </div>

          <div className="form-group">
            <label>Data documentului</label>
            <input
              type="date"
              name="documentDate"
              value={formData.documentDate}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label>Descriere</label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label>Referință</label>
            <input
              type="text"
              name="reference"
              value={formData.reference}
              onChange={handleInputChange}
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label>Repetabil</label>
            <input
              type="checkbox"
              name="repeatable"
              checked={formData.repeatable}
              onChange={handleInputChange}
            />
          </div>

          <button onClick={handleAddExpense} className="form-submit-button">
            Adaugă
          </button>
        </div>

        <div className="expenses-list">
          {expenses.map((expense, index) => (
            <div className="expense-item" key={index}>
              <div><strong>Furnizor:</strong> {expense.provider}</div>
              <div><strong>Serial Number:</strong> {expense.serialNumber}</div>
              <div><strong>Suma:</strong> {expense.amount}</div>
              <div><strong>Tip consum (ordinal):</strong> {expense.consumptionType}</div>
              <div><strong>Data documentului:</strong> {expense.documentDate}</div>
              <div><strong>Descriere:</strong> {expense.description}</div>
              <div><strong>Referință:</strong> {expense.reference}</div>
              <div><strong>Repetabil:</strong> {expense.repeatable ? "Da" : "Nu"}</div>
              <div>
                <strong>Lista Apartamente:</strong>{" "}
                {expense.houseHoldList.map(h => (
                  <span key={h.id}>{h.apartmentNumber} </span>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ExpensesPage;
