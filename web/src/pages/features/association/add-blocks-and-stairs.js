import React, { useState, useEffect, useCallback } from "react";
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

  const loadBlocks = useCallback(async () => {
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
  }, [associationId]);

  useEffect(() => {
    loadBlocks();
  }, [associationId, loadBlocks]);

  const addBlock = async () => {
    if (blockName.trim() === "") return;
    const token = localStorage.getItem("access_token");
    try {
      const apiUrl = process.env.REACT_APP_API_URL;
      await axios.post(
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

     
      setTimeout(() => {
        setBlocksSubmitted(false);
      }, 3000);
    } catch (error) {
      console.error("Eroare la adăugarea blocului:", error);
    }
  };

  const addStair = async () => {
    if (!selectedBlockId || stairName.trim() === "") return;
    const token = localStorage.getItem("access_token");
    try {
      const apiUrl = process.env.REACT_APP_API_URL;
      await axios.post(
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
    <div className="add-blocks-container-unique-all">
      <div className="add-blocks-container-unique">
        <Sidebar />
        <div className="add-blocks-left-unique">
          <h2 className="add-blocks-title-unique">1. Adaugă Blocuri</h2>
          <div className="form-row-unique">
            <input
              type="text"
              placeholder="Nume Bloc"
              value={blockName}
              onChange={(e) => setBlockName(e.target.value)}
              className="block-name-input-unique"
            />
            <button onClick={addBlock} className="add-block-button-unique">Adaugă Bloc</button>
          </div>
          {isLoading && <p>Se încarcă blocurile...</p>}
          {blocksSubmitted && <p>Blocul a fost adăugat cu succes!</p>}
        </div>

        <div className="add-blocks-right-unique">
          <h2 className="add-stairs-title-unique">2. Adaugă Scări</h2>
          <select
            value={selectedBlockId}
            onChange={(e) => setSelectedBlockId(e.target.value)}
            className="block-select-unique"
          >
            <option value="">Selectează un bloc</option>
            {blocks.map((block) => (
              <option key={block.id} value={block.id}>
                {block.name}
              </option>
            ))}
          </select>
          <div className="form-row-unique">
            <input
              type="text"
              placeholder="Nume Scară"
              value={stairName}
              onChange={(e) => setStairName(e.target.value)}
              className="stair-name-input-unique"
            />
            <button onClick={addStair} className="add-stair-button-unique">Adaugă Scară</button>
          </div>
        </div>
      </div>

      <div className="add-blocks-list-container">
        <h3>Blocuri și Scări Adăugate:</h3>
        <div className="add-blocks-list">
          {blocks.length > 0 ? (
            blocks.map((block) => (
              <div key={block.id} className="block-details">
                <p><strong>Bloc:</strong> {block.name}</p>
                <p><strong>Scări:</strong> {block.stairs.map((stair, index) => (
                  <span key={index}>{stair.name} </span>
                ))}</p>
              </div>
            ))
          ) : (
            <p>Nu există blocuri sau scări adăugate.</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default AddBlocksAndStairsPage;
