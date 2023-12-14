import React, { useState } from "react";
import "./login.css";
import InputField from "../../InputFeild/InputField";
import { signInWithEmailAndPassword } from "firebase/auth";
import CarPool from "../../assets/CarPool.png";
import { auth } from "../../firebaseConfig";
import { NavLink, useNavigate, Link } from "react-router-dom";
import { toast } from "react-toastify";

export default function Login() {
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);

  const handleSubmit = (event) => {
    event.preventDefault();
    signInWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        toast.success("Logged in successfully");
        const user = userCredential.user;
        navigate("/landing");
        console.log(user);
      })
      .catch((error) => {
        toast.error("Wrong email or password");
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
          Log In
        </button>
        <p className="NewAcc">
          Don't have an account?{" "}
          <a className="signUp">
            <Link to="/signup">Sign up</Link>
          </a>
          .
        </p>
      </form>
    </div>
  );
}
