// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAEXyUohZT4Aowp3QpL768S4Dfk8BtfFGI",
  authDomain: "login-carpool.firebaseapp.com",
  projectId: "login-carpool",
  storageBucket: "login-carpool.appspot.com",
  messagingSenderId: "9403965209",
  appId: "1:9403965209:web:2e0c4f308c14648a72ef88",
  measurementId: "G-8LCBL6M78H",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

export const auth = getAuth(app);
