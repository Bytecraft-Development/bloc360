import React, { useState, useEffect } from "react";
import axios from "axios";
import Sidebar from "../components/sidemenu";
import { useParams } from "react-router-dom";
import "../../../pages/features/styles/addohousehold.css";

const AddHouseHold = () => {
  const { associationId } = useParams();
  const [blocks, setBlocks] = useState([]);
  const [stairs, setStairs] = useState([]);
  const [selectedStair, setSelectedStair] = useState(null);
  const [apartmentData, setApartmentData] = useState([
    { apartmentNumber: "", numberOfHouseHoldMembers: 1, surface: 0.0 },
  ]);

  useEffect(() => {
    const fetchBlocks = async () => {
      try {
        const apiUrl = process.env.REACT_APP_API_URL;
        const response = await axios.get(`${apiUrl}/blocks?associationId=${associationId}`);
        setBlocks(response.data); 
      } catch (error) {
        console.error("Error fetching blocks:", error);
      }
    };

    fetchBlocks(); 
  }, [associationId]); 

  const handleBlockSelect = (block) => {
    setStairs(block.stairs || []);
    setSelectedStair(null);
    setApartmentData([{ apartmentNumber: "", numberOfHouseHoldMembers: 1, surface: 0.0 }]);
  };

  const handleStairSelect = (stairId) => {
    setSelectedStair(stairs.find((stair) => stair.id === parseInt(stairId)));
    setApartmentData([{ apartmentNumber: "", numberOfHouseHoldMembers: 1, surface: 0.0 }]);
  };
 
  const handleInputChange = (index, field, value) => {
    const newData = [...apartmentData];
    newData[index][field] = value;
    setApartmentData(newData);
  };

  const handleAddLine = () => {
    setApartmentData([
      ...apartmentData,
      { apartmentNumber: "", numberOfHouseHoldMembers: 1, surface: 0.0 },
    ]);
  };

  const handleSubmit = async () => {
    try {
      const apiUrl = process.env.REACT_APP_API_URL;
  
      const payload = apartmentData.map((row) => ({
        apartmentNumber: row.apartmentNumber,
        stairId: selectedStair.id,
        numberOfHouseHoldMembers: row.numberOfHouseHoldMembers,
        surface: row.surface,
      }));
  
      
      const response = await axios.post(
        `${apiUrl}/addHouseHoldToStair?stairId=${selectedStair.id}`,
        payload,
        {
          headers: {
            "Content-Type": "application/json",
          },
        }
      );
      if (response.status === 200 || response.status === 201) {
        alert("HouseHold adăugat cu succes!");
      }
    } catch (error) {
      console.error("Error adding household:", error);
      alert("Eroare la adăugarea household-ului.");
    }
  };

  return (
    <div className="add-household-container">
      <div className="add-household-content">
        <h1 className="add-household-title">Configurare</h1>

      
         <div className="add-household-selectors">
          <div className="block-section">
            <label className="label-with-line">
              Selectați un bloc:
              <div className="line"></div>
              <select
                className="input-select"
                onChange={(e) => handleBlockSelect(JSON.parse(e.target.value))}
              >
                <option value="">Selectează bloc</option>
                {blocks.map((block) => (
                  <option key={block.id} value={JSON.stringify(block)}>
                    {block.name}
                  </option>
                ))}
              </select>
            </label>
          </div>

        
          <div className="stair-section">
            <label className="label-with-line">
              Selectați o scară:
              <div className="line"></div>
              <select
                className="input-select"
                onChange={(e) => handleStairSelect(e.target.value)}
              >
                <option value="">Selectează scară</option>
                {stairs.map((stair) => (
                  <option key={stair.id} value={stair.id}>
                    {stair.name}
                  </option>
                ))}
              </select>
            </label>
          </div>
        </div>

       
        {selectedStair && (
  <div className="apartment-inputs-table">
   
    <div className="input-row">
      <div className="input-header">Nr. Apartament</div>
      <div className="input-header">Nr. persoane</div>
      <div className="input-header">Suprafață</div>
    </div>
    {apartmentData.map((row, index) => (
      <div className="input-row" key={index}>
        <input
          className="input-field small-input"
          type="text"
          value={row.apartmentNumber}
          onChange={(e) =>
            handleInputChange(index, "apartmentNumber", e.target.value)
          }
        />
        <input
          className="input-field small-input"
          type="number"
          value={row.numberOfHouseHoldMembers}
          onChange={(e) =>
            handleInputChange(index, "numberOfHouseHoldMembers", e.target.value)
          }
        />
        <input
          className="input-field small-input"
          type="number"
          step="0.01"
          value={row.surface}
          onChange={(e) =>
            handleInputChange(index, "surface", e.target.value)
          }
        />
        {index === 0 && (
          <button className="add-line-button" onClick={handleAddLine}>
            +
          </button>
        )}
      </div>
    ))}
  </div>
)}
       
        {selectedStair && (
          <div className="submit-section">
            <button className="submit-button" onClick={handleSubmit}>
              Trimite Household
            </button>
          </div>
        )}
      </div>
      <Sidebar />
    </div>
  );
};

export default AddHouseHold;
