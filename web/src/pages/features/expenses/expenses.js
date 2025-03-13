"use client";

import { useState, useEffect } from "react";
import { MultiSelect } from "react-multi-select-component";
import "../../../pages/features/styles/expenses.css";
import Sidebar from '../components/sidemenu';

const CustomOption = ({ option, isSelected, selectOption, percentages, onPercentageChange, formData }) => {
  const isSelectAll =
    option.label === "Select All" ||
    option.label === "Selectează toate blocurile" ||
    option.label === "Selectează toate scările" ||
    option.label === "Selectează toate apartamentele";

  return (
    <div className="custom-option">
      <div className="option-content">
        <input
          type="checkbox"
          checked={isSelected}
          onChange={() => selectOption(option)}
          className="option-checkbox"
        />
        <span className="option-label">{option.label}</span>
      </div>
      {isSelected && !isSelectAll && formData.expenseDistributionType === "FIXED_PERCENTAGE" && (
        <div className="option-percentage">
          <input
            type="number"
            value={percentages[option.value] || ""}
            onChange={(e) => onPercentageChange(option.value, e.target.value)}
            className="percentage-input-small"
            placeholder="0"
            min="0"
            max="100"
            onClick={(e) => e.stopPropagation()}
          />
          <span className="percentage-symbol-small">%</span>
        </div>
      )}
    </div>
  );
};

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
    expenseDistributionType: "EQUALLY",
  });

  const [expenses, setExpenses] = useState([]);
  const [blocks, setBlocks] = useState([]);
  const [stairs, setStairs] = useState([]);
  const [apartments, setApartments] = useState([]);
  const [selectedType, setSelectedType] = useState("BLOC");
  const [selectedBlocks, setSelectedBlocks] = useState([]);
  const [selectedStairs, setSelectedStairs] = useState([]);
  const [selectedApartments, setSelectedApartments] = useState([]);
  const [selectedBlockNative, setSelectedBlockNative] = useState("");
  const [selectedStairNative, setSelectedStairNative] = useState("");
  const [apartmentPercentages, setApartmentPercentages] = useState({});

  useEffect(() => {
    const fetchBlocks = async () => {
      try {
        const apiUrl = process.env.REACT_APP_API_URL;
        const response = await fetch(`${apiUrl}/blocks?associationId=1`);
        if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
        const data = await response.json();
        setBlocks(data);
      } catch (error) {
        console.error("Error fetching blocks:", error);
      }
    };
    fetchBlocks();
  }, []);

  useEffect(() => {
    if (selectedBlockNative) {
      const block = blocks.find((b) => b.id === Number.parseInt(selectedBlockNative));
      setStairs(block ? block.stairs : []);
      setSelectedStairNative("");
      setSelectedStairs([]);
      setApartments([]);
      setSelectedApartments([]);
    }
  }, [selectedBlockNative, blocks]);

  useEffect(() => {
    if (selectedStairNative) {
      const fetchApartments = async () => {
        try {
          const apiUrl = process.env.REACT_APP_API_URL;
          const response = await fetch(`${apiUrl}/stair?stairId=${selectedStairNative}`);
          if (!response.ok) throw new Error("HTTP error fetching apartments");
          const apartmentsData = await response.json();
          setApartments(apartmentsData);
          setSelectedApartments([]);
        } catch (error) {
          console.error("Error fetching apartments:", error);
        }
      };
      fetchApartments();
    }
  }, [selectedStairNative]);

  const handlePercentageChange = (apartmentId, value) => {
    setApartmentPercentages((prev) => ({
      ...prev,
      [apartmentId]: value,
    }));
  };

  const handleTypeChange = (e) => {
    setSelectedType(e.target.value);
    setSelectedBlocks([]);
    setSelectedStairs([]);
    setSelectedApartments([]);
    setSelectedBlockNative("");
    setSelectedStairNative("");
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
      if (selectedBlocks.length === 0) {
        console.error("Selectați cel puțin un bloc!");
        return;
      }
      const selectedIds = selectedBlocks.map((b) => b.value);
      try {
        const query = selectedIds.map((id) => `blockIds=${id}`).join("&");
        const response = await fetch(`${apiUrl}/householdsByBlock?${query}`);
        if (!response.ok) throw new Error("Error fetching households by block");
        const households = await response.json();
        householdIds = households.map((h) => h.id);
      } catch (error) {
        console.error(error);
        return;
      }
    } else if (selectedType === "SCARA") {
      if (selectedStairs.length === 0) {
        console.error("Selectați cel puțin o scară!");
        return;
      }
      try {
        const results = await Promise.all(
          selectedStairs.map((s) =>
            fetch(`${apiUrl}/stair?stairId=${s.value}`).then((r) => r.json())
          )
        );
        householdIds = results.flat().map((h) => h.id);
      } catch (error) {
        console.error(error);
        return;
      }
    } else if (selectedType === "APARTAMENT") {
      if (selectedApartments.length === 0) {
        console.error("Selectați cel puțin un apartament!");
        return;
      }
      householdIds = selectedApartments.map((a) => a.value);
    }
  
    if (householdIds.length === 0) {
      console.error("Lista householdIds este goală!");
      return;
    }
  
    
    const expenseHouseholds = householdIds.map((id) => ({
      houseHold: { id },
      percentage: formData.expenseDistributionType === "FIXED_PERCENTAGE" ? (apartmentPercentages[id] || 0) : null,
    }));
  
    const expenseData = {
      provider: formData.provider,
      serialNumber: formData.serialNumber,
      amount: Number.parseFloat(formData.amount),
      consumptionType: formData.consumptionType,
      documentDate: formData.documentDate,
      description: formData.description,
      expenseDistributionType: formData.expenseDistributionType, 
      reference: formData.reference,
      repeatable: formData.repeatable,
      expenseHouseholds,
    };
  
    console.log("JSON trimis:", JSON.stringify(expenseData, null, 2));
  
    try {
      const response = await fetch(`${apiUrl}/createExpense`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(expenseData),
      });
      if (!response.ok) throw new Error("Error sending expense");
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
        expenseDistributionType: "EQUALLY",
      });
      setSelectedBlocks([]);
      setSelectedStairs([]);
      setSelectedApartments([]);
      setSelectedBlockNative("");
      setSelectedStairNative("");
    } catch (error) {
      console.error(error);
    }
  };

  
  const PercentageInputs = ({ items, percentages, onChange }) => {
    return (
      <div className="percentage-inputs">
        {items.map((item) => (
          <div key={item.value} className="percentage-input-item">
            <span className="percentage-label">{item.label}</span>
            <div className="percentage-input-wrapper">
              <input
                type="number"
                value={percentages[item.value] || ""}
                onChange={(e) => onChange(item.value, e.target.value)}
                className="percentage-input"
                placeholder="0"
                min="0"
                max="100"
              />
              <span className="percentage-symbol">%</span>
            </div>
          </div>
        ))}
      </div>
    );
  };

  const renderDynamicSelections = () => {
    if (selectedType === "BLOC") {
      return (
        <div className="expense-form-group">
          <label className="expense-label">Blocuri disponibile</label>
          <div className="select-with-percentages">
            <div className="multi-select-wrapper">
              <MultiSelect
                options={blocks.map((b) => ({ label: b.name, value: b.id }))}
                value={selectedBlocks}
                onChange={setSelectedBlocks}
                labelledBy="Selectează blocuri"
                className="custom-multi-select"
                overrideStrings={{
                  allItemsAreSelected: "Toate blocurile selectate",
                  selectAll: "Selectează toate blocurile",
                }}
                ItemRenderer={({ option, checked, onClick }) => (
                  <CustomOption
                    option={option}
                    isSelected={checked}
                    selectOption={onClick}
                    percentages={apartmentPercentages}
                    onPercentageChange={handlePercentageChange}
                    formData={formData}
                  />
                )}
              />
            </div>
          </div>
        </div>
      );
    } else if (selectedType === "SCARA" || selectedType === "APARTAMENT") {
      return (
        <>
          <div className="expense-form-group">
            <label className="expense-label">Selectează Bloc</label>
            <div className="select-wrapper">
              <select
                onChange={(e) => setSelectedBlockNative(e.target.value)}
                className="expense-input"
                value={selectedBlockNative}
              >
                <option value="">Selectează blocul</option>
                {blocks.map((block) => (
                  <option key={block.id} value={block.id}>
                    {block.name}
                  </option>
                ))}
              </select>
              <span className="select-icon">▼</span>
            </div>
          </div>

          {selectedBlockNative && selectedType === "SCARA" && (
            <div className="expense-form-group">
              <label className="expense-label">Scări disponibile</label>
              <div className="select-with-percentages">
                <div className="multi-select-wrapper">
                  <MultiSelect
                    options={stairs.map((s) => ({ label: s.name, value: s.id }))}
                    value={selectedStairs}
                    onChange={setSelectedStairs}
                    labelledBy="Selectează scări"
                    className="custom-multi-select"
                    overrideStrings={{
                      allItemsAreSelected: "Toate scările selectate",
                      selectAll: "Selectează toate scările",
                    }}
                    ItemRenderer={({ option, checked, onClick }) => (
                      <CustomOption
                        option={option}
                        isSelected={checked}
                        selectOption={onClick}
                        percentages={apartmentPercentages}
                        onPercentageChange={handlePercentageChange}
                        formData={formData}
                      />
                    )}
                  />
                </div>
              </div>
            </div>
          )}

          {selectedBlockNative && selectedType === "APARTAMENT" && (
            <>
              <div className="expense-form-group">
                <label className="expense-label">Selectează Scara</label>
                <div className="select-wrapper">
                  <select
                    onChange={(e) => setSelectedStairNative(e.target.value)}
                    className="expense-input"
                    value={selectedStairNative}
                  >
                    <option value="">Selectează scara</option>
                    {stairs.map((stair) => (
                      <option key={stair.id} value={stair.id}>
                        {stair.name}
                      </option>
                    ))}
                  </select>
                  <span className="select-icon">▼</span>
                </div>
              </div>

              {selectedStairNative && (
                <div className="expense-form-group">
                  <label className="expense-label">Apartamente disponibile</label>
                  <div className="select-with-percentages">
                    <div className="multi-select-wrapper">
                      <MultiSelect
                        options={apartments.map((a) => ({ label: a.apartmentNumber, value: a.id }))}
                        value={selectedApartments}
                        onChange={setSelectedApartments}
                        labelledBy="Selectează apartamente"
                        className="custom-multi-select"
                        overrideStrings={{
                          allItemsAreSelected: "Toate apartamentele selectate",
                          selectAll: "Selectează toate apartamentele",
                        }}
                        ItemRenderer={({ option, checked, onClick }) => (
                          <CustomOption
                            option={option}
                            isSelected={checked}
                            selectOption={onClick}
                            percentages={apartmentPercentages}
                            onPercentageChange={handlePercentageChange}
                            formData={formData}
                          />
                        )}
                      />
                    </div>
                  </div>
                </div>
              )}
            </>
          )}
        </>
      );
    }
    return null;
  };


  
const [sidebarOpen, setSidebarOpen] = useState(false);
  const handleSidebarToggle = (isOpen) => {
    setSidebarOpen(isOpen)
  }
    return (
      <div className="app-container">
        <Sidebar onToggle={handleSidebarToggle} />
        <div className={`expenses-page-container ${!sidebarOpen ? "sidebar-closed" : ""}`}>
          <div className="expenses-page-content">
            <header className="expense-header">
              <h1>Cheltuieli asociație</h1>
              <div className="expense-header-actions">
                <div className="select-wrapper">
                  <select className="expense-select">
                    <option>Noiembrie</option>
                  </select>
                  <span className="select-icon">▼</span>
                </div>
                <button className="expense-add-button" onClick={handleAddExpense}>
                  <span className="add-button-icon">+</span> Adaugă factura
                </button>
                <button className="expense-close-month-button">Închide luna</button>
              </div>
            </header>
  
            <div className="expense-form">
              {/* Row 1: Date, Provider, Serial Number, Amount */}
              <div className="expense-row">
                <div className="expense-form-group">
                  <label className="expense-label">Data</label>
                  <input
                    type="date"
                    name="documentDate"
                    value={formData.documentDate}
                    onChange={handleInputChange}
                    className="expense-input"
                  />
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Furnizor</label>
                  <input
                    type="text"
                    name="provider"
                    value={formData.provider}
                    onChange={handleInputChange}
                    className="expense-input"
                    placeholder="Electrica distribuție Nord Cluj"
                  />
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Serie și nr.</label>
                  <input
                    type="text"
                    name="serialNumber"
                    value={formData.serialNumber}
                    onChange={handleInputChange}
                    className="expense-input"
                    placeholder="ASFX CJ 1256355896123598745"
                  />
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Suma</label>
                  <div className="currency-input-wrapper">
                    <input
                      type="number"
                      name="amount"
                      value={formData.amount}
                      onChange={handleInputChange}
                      className="expense-input"
                      placeholder="123459.78"
                    />
                    <span className="currency-symbol">RON</span>
                  </div>
                </div>
              </div>
  
              {/* Row 2: Distribution method, Recipient selection and dynamic selections */}
              <div className="expense-row dynamic-row">
                <div className="expense-form-group">
                  <label className="expense-label">Mod repartizare</label>
                  <div className="select-wrapper">
                    <select
                      name="expenseDistributionType"
                      value={formData.expenseDistributionType}
                      onChange={handleInputChange}
                      className="expense-input"
                    >
                      <option value="EQUALLY">Egal</option>
                      <option value="BY_NUMBER_OF_PEOPLE">După număr de persoane</option>
                      <option value="BY_SURFACE">După suprafață</option>
                      <option value="BY_INDEX">După index</option>
                      <option value="FIXED_PERCENTAGE">Procent fix</option>
                    </select>
                    <span className="select-icon">▼</span>
                  </div>
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Repartizată către</label>
                  <div className="select-wrapper">
                    <select name="category" value={selectedType} onChange={handleTypeChange} className="expense-input">
                      <option value="BLOC">Bloc</option>
                      <option value="SCARA">Scară</option>
                      <option value="APARTAMENT">Apartament</option>
                    </select>
                    <span className="select-icon">▼</span>
                  </div>
                </div>
                {renderDynamicSelections()}
              </div>
  
              {/* Row 3: Document, Repeatable, Description, Consumption Type */}
              <div className="expense-row">
                <div className="expense-form-group">
                  <label className="expense-label">Document</label>
                  <div className="expense-file-input">
                    <input type="text" value="electrica noiembrie.pdf" readOnly className="expense-input" />
                    <button className="expense-file-button">+</button>
                  </div>
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Recurentă</label>
                  <div className="select-wrapper">
                    <select
                      name="repeatable"
                      value={formData.repeatable ? "Da" : "Nu"}
                      onChange={(e) => setFormData({ ...formData, repeatable: e.target.value === "Da" })}
                      className="expense-input"
                    >
                      <option value="Da">Da</option>
                      <option value="Nu">Nu</option>
                    </select>
                    <span className="select-icon">▼</span>
                  </div>
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Descriere</label>
                  <input
                    type="text"
                    name="description"
                    value={formData.description}
                    onChange={handleInputChange}
                    className="expense-input"
                    placeholder="Curent casa scării"
                  />
                </div>
                <div className="expense-form-group">
                  <label className="expense-label">Tip Consum</label>
                  <div className="select-wrapper">
                    <select
                      name="consumptionType"
                      value={formData.consumptionType}
                      onChange={handleInputChange}
                      className="expense-input"
                    >
                      <option value="ELECTRICITY">Energie electrica</option>
                      <option value="COLD_WATER">Apa rece</option>
                      <option value="HOT_WATER">Apa calda</option>
                      <option value="HEATING">Incalzire</option>
                    </select>
                    <span className="select-icon">▼</span>
                  </div>
                </div>
              </div>
  
              {/* Row 4 (Conditional): Percentage inputs for selections */}
              {formData.expenseDistributionType === "FIXED_PERCENTAGE" &&
                (selectedType === "SCARA" || selectedType === "APARTAMENT") &&
                (selectedStairs.length > 0 || selectedApartments.length > 0) && (
                  <div className="expense-row">
                    <div className="expense-form-group">
                      {selectedType === "SCARA" && selectedStairs.length > 0 ? (
                        <PercentageInputs
                          items={selectedStairs.map((s) => ({ label: s.label, value: s.value }))}
                          percentages={apartmentPercentages}
                          onChange={handlePercentageChange}
                        />
                      ) : selectedType === "APARTAMENT" && selectedApartments.length > 0 ? (
                        <PercentageInputs
                          items={selectedApartments.map((a) => ({ label: a.label, value: a.value }))}
                          percentages={apartmentPercentages}
                          onChange={handlePercentageChange}
                        />
                      ) : null}
                    </div>
                  </div>
                )}
  
              <div className="expense-form-actions">
                <button className="expense-settings-button">
                  <span className="settings-icon">⚙️</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
  
  export default ExpensesPage
  
  