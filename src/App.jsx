import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import Login from "./screens/Login/Login";
import { BrowserRouter as Router } from "react-router-dom";
import { Routes, Route } from "react-router-dom";
import Landing from "./screens/Landing/Landing";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import Signup from "./screens/Signup/Signup";

function App() {
  return (
    <>
      <Router>
        <ToastContainer theme="colored" />
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/landing" element={<Landing />} />
        </Routes>
      </Router>
    </>
  );
}

export default App;
