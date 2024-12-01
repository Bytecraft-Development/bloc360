import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
import Sidebar from "../components/sidemenu";
import "../../../pages/features/styles/addblocksandstairs.css";

const AddBlocksAndStairsPage = () => {
  const { associationId } = useParams(); 
  const [blockName, setBlockName] = useState("");
  const [stairName, setStairName] = useState("");
  const [blocks, setBlocks] = useState([]);
  const [selectedBlockId, setSelectedBlockId] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [blocksSubmitted, setBlocksSubmitted] = useState(false);

 
  const loadBlocks = async () => {
    setIsLoading(true);
    const token = localStorage.getItem("access_token");
    try {
       const apiUrl = process.env.REACT_APP_API_URL;
      const response = await axios.get(
        `${apiUrl}/blocks?associationId=${associationId}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setBlocks(response.data.map(block => ({
        id: block.id,
        name: block.name,
        stairs: block.stairs || [],
      })));
    } catch (error) {
      console.error("Eroare la încărcarea blocurilor:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadBlocks();
  }, [associationId]);

 
  const addBlock = async () => {
    
    if (blockName.trim() === "") return;
    const token = localStorage.getItem("access_token");
    try {
     const apiUrl = process.env.REACT_APP_API_URL;
      const response = await axios.post(
        `${apiUrl}/addBlocks?associationId=${associationId}`,
        [{ name: blockName }],
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setBlockName(""); 
      setBlocksSubmitted(true);
      loadBlocks(); 
    } catch (error) {
      console.error("Eroare la adăugarea blocului:", error);
    }
  };

 
  const addStair = async () => {
    if (!selectedBlockId || stairName.trim() === "") return;
    const token = localStorage.getItem("access_token");
    try {
      const apiUrl = process.env.REACT_APP_API_URL;
      
      const response = await axios.post(
        `${apiUrl}/addStair?blockId=${selectedBlockId}`,
        [{ name: stairName }],
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setStairName("");
      loadBlocks(); 
    } catch (error) {
      console.error("Eroare la adăugarea scării:", error);
    }
  };

  return (
    <div className="add-blocks-container">
      <Sidebar />
      
      
      <div className="add-blocks-left">
        <h2>1. Adaugă Blocuri</h2>
        <div className="form-row">
          <input
            type="text"
            placeholder="Nume Bloc"
            value={blockName}
            onChange={(e) => setBlockName(e.target.value)}
          />
          <button onClick={addBlock} className="add-button">Adaugă Bloc</button>
        </div>
      </div>
  
     
      <div className="add-blocks-right">
        <h2>2. Adaugă Scări</h2>
        <select
          value={selectedBlockId}
          onChange={(e) => setSelectedBlockId(e.target.value)}
        >
          <option value="">Selectează un bloc</option>
          {blocks.map((block) => (
            <option key={block.id} value={block.id}>
              {block.name}
            </option>
          ))}
        </select>
        <div className="form-row">
          <input
            type="text"
            placeholder="Nume Scară"
            value={stairName}
            onChange={(e) => setStairName(e.target.value)}
          />
          <button onClick={addStair} className="add-button">Adaugă Scară</button>
        </div>
      </div>
    </div>
  );
};

export default AddBlocksAndStairsPage;
