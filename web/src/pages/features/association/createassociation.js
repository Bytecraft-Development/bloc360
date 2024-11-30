import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import Sidebar from "../components/sidemenu";
import "../../../pages/features/styles/createassociation.css";

const CreateAssociationPage = () => {
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    name: "",
    address: "",
    cui: "",
    registerComert: "",
    bankAccount: "",
    bankName: "",
    indexDate: "",
    coldWater: false,
    hotWater: false,
    gas: false,
    heating: false,
  });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleCheckboxChange = (e) => {
    const { name, checked } = e.target;
    setFormData({ ...formData, [name]: checked });
  };

  const getToken = async () => {
    return localStorage.getItem("access_token");
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const apiUrl = config.apiUrl;

    const token = await getToken();
    if (!token) {
      alert("Authentication token is missing.");
      return;
    }

    try {
      const response = await axios.post(
        `${apiUrl}/createAssociation`,
        formData,
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (response.status === 200) {
        const { associationId } = response.data;
        navigate(`/add-blocks-and-stairs/${associationId}`);
      } else {
        alert("Error creating association.");
      }
    } catch (error) {
      console.error("Error:", error);
      alert("Error creating association.");
    }
  };

  return (
    <div className="create-association-container">
      <Sidebar />
      <div className="create-association-content">
        <form onSubmit={handleSubmit} className="create-association-form">
          <h1 className="form-title">Crează Asociație</h1>

          <div className="form-row">
            <TextInput
              label="Denumire legală"
              name="name"
              value={formData.name}
              onChange={handleInputChange}
            />
            <TextInput
              label="Nr. registru comerț"
              name="registerComert"
              value={formData.registerComert}
              onChange={handleInputChange}
            />
          </div>

          <div className="form-row">
            <TextInput
              label="Adresă"
              name="address"
              value={formData.address}
              onChange={handleInputChange}
            />
            <TextInput
              label="Banca"
              name="bankName"
              value={formData.bankName}
              onChange={handleInputChange}
            />
          </div>

          <div className="form-row">
            <TextInput
              label="CUI"
              name="cui"
              value={formData.cui}
              onChange={handleInputChange}
            />
            <TextInput
              label="IBAN"
              name="bankAccount"
              value={formData.bankAccount}
              onChange={handleInputChange}
            />
          </div>
   
          <h2 className="section-title">Contoare</h2>
          <div className="form-row checkboxes-row">
            <label className="checkbox-label">
            <input type="checkbox"/>
              <input
                type="checkbox"
                name="coldWater"
                checked={formData.coldWater}
                onChange={handleCheckboxChange}
                className="checkbox-input"
              />
              Apă rece
            </label>
            <label className="checkbox-label">
            <input type="checkbox"/>
              <input
                type="checkbox"
                name="hotWater"
                checked={formData.hotWater}
                onChange={handleCheckboxChange}
                className="checkbox-input"
              />
              Apă caldă
            </label>
            <label className="checkbox-label">
              <input
                type="checkbox"
                name="gas"
                checked={formData.gas}
                onChange={handleCheckboxChange}
                className="checkbox-input"
              />
              Gaz
            </label>
            <label className="checkbox-label">
              <input
                type="checkbox"
                name="heating"
                checked={formData.heating}
                onChange={handleCheckboxChange}
                className="checkbox-input"
              />
              Încălzire
            </label>
          </div>

          <h2 className="section-title">Ziua Emiterii Facturilor</h2>
          <TextInput
            label="Introduceți ziua"
            name="indexDate"
            value={formData.indexDate}
            onChange={handleInputChange}
          />

          <div className="form-submit">
            <button type="submit" className="submit-button">
              Pasul următor
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

const TextInput = ({ label, name, value, onChange }) => (
  <div className="text-input">
    <label className="input-label">{label}</label>
    <input
      type="text"
      name={name}
      value={value}
      onChange={onChange}
      className="input-field"
    />
  </div>
);

export default CreateAssociationPage;
