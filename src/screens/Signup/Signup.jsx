import React, { useState } from "react";
import "./signup.css";
import InputField from "../../InputFeild/InputField";
import CarPool from "../../assets/CarPool.png";
import { auth } from "../../firebaseConfig";
import { NavLink, useNavigate, Link } from "react-router-dom";
import { toast } from "react-toastify";
import { createUserWithEmailAndPassword } from "firebase/auth";

export default function Signup() {
  const navigate = useNavigate();

  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);

  const handleSubmit = (event) => {
    event.preventDefault();
    createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        const user = userCredential.user;
        toast.success("Account created successfully");
        navigate("/login");
        console.log(user);
      })
      .catch((error) => {
        toast.error("Something went wrong, please try again");
        const errorCode = error.code;
        const errorMessage = error.message;
        console.log(errorCode);
        console.log(errorMessage);
      });
  };

  return (
    <div className="contaioner">
      <img className="logo" src={CarPool} alt="Logo" />
      <h1 className="title">Welcome Back!</h1>
      <h2 className="subtitle">Driver View</h2>
      <form onSubmit={handleSubmit} className="form">
        <div className="inputs">
          <InputField
            label="Name"
            type="name"
            placeholder="Ziad Nasr"
            setValue={(e) => setName(e.target.value)}
          />
          <InputField
            label="E-mail"
            type="email"
            placeholder="19P****@eng.asu.edu.eg"
            setValue={(e) => setEmail(e.target.value)}
          />
          <InputField
            label="Password"
            type="password"
            placeholder="********"
            setValue={(e) => setPassword(e.target.value)}
          />
          <div className="chackbox">
            <label className="checkboxLabel">Remember me</label>
            <input
              type="checkbox"
              checked={rememberMe}
              onChange={(e) => setRememberMe(e.target.checked)}
            />
          </div>
        </div>
        <button type="submit" className="login">
          Sign Up
        </button>
        <p className="NewAcc">
          Already signed up?
          <a className="signUp">
            <Link to="/signup"> Log in</Link>
          </a>
          .
        </p>
      </form>
    </div>
  );
}
