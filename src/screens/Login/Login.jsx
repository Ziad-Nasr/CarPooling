import React from "react";
import { useState } from "react";
import "./login.css";
import InputField from "../../InputFeild/InputField";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);

  const handleSubmit = (event) => {
    event.preventDefault();
    // Handle form submission here
    console.log(
      `Email: ${email}, Password: ${password}, Remember Me: ${rememberMe}`
    );
  };

  return (
    <div className="contaioner">
      <h1>Welcome Back!</h1>
      <h2>Driver View</h2>
      <form onSubmit={handleSubmit} className="form">
        <InputField
          label="Email"
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
        <label>
          Remember me
          <input
            type="checkbox"
            checked={rememberMe}
            onChange={(e) => setRememberMe(e.target.checked)}
          />
        </label>
        <button type="submit" className="login">Log In</button>
      </form>
    </div>
  );
}
