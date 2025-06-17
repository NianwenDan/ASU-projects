![Phishy Logo](public/icons/phishy-128.png)

# CSE 543 - Group 13 - Phishy  
⚠️**This is a forked repository from [github.com/aad8ya/phishy](https://github.com/aad8ya/phishy)**⚠️

Machine Learning-based Phishing Website Detection

## 🧑‍💻 Team Members

- **Adithya Ganesan** – Team Leader  
- **Nianwen Dan** – Deputy Leader  
- Jiayuan Yu  
- Madumita Karthikeyan  
- Moksha Smruthi Morapakula  
- Pranesh Somasundar  
- Wenqi Liu  

---

## 🧠 Project Description

**Phishy** is a Chrome browser extension that detects phishing websites in real time using machine learning and threat intelligence sources. Built as a course project for *CSE 543: Information Assurance and Security* at Arizona State University, this tool aims to provide users with an extra layer of protection against malicious websites.  

The extension checks URLs against Google Safe Browsing and uses a lightweight ONNX-based machine learning model to predict phishing intent based on structural and lexical features of the URL.

---

## ⚙️ How to Install

### Prerequisites

- **Node.js** (v16+)
- **Yarn**
- **Google Chrome**
- **Google Safe Browsing API key**  
  (You can obtain one for free from [Google Cloud Console](https://console.cloud.google.com/apis/library/safebrowsing.googleapis.com))

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/aad8ya/phishy.git
   cd phishy
   ```

2. **Install Dependencies**

   ```bash
   yarn install
   ```

3. **Configure the API Key**

   - Create a `.env` file in the project root:

     ```
     VITE_GOOGLE_API=your-api-key-here
     ```

4. **Build the Extension**

   ```bash
   yarn build
   ```
   This will generate a `dist/` folder containing the built extension.



5. **Load the Extension in Chrome**

- Navigate to `chrome://extensions/`
- Enable **Developer Mode**
- Click **Load Unpacked**
- Select the `dist/` directory

---

## 📚 Technical Documentation

### 🔍 Features

- **Automatic Phishing Check**  
  On every page load, the extension automatically checks the current URL for phishing threats.

- **Safe Browsing Integration**  
  URLs are cross-referenced with Google's Safe Browsing API.

- **ONNX Model Inference** 
  A sandboxed iframe will run an ONNX ML model for additional phishing detection based on URL patterns.

- **Popup Interface**  
  Displays URL status with a manual “Recheck” button.

- **Result Caching**  
  Uses `chrome.storage.local` to cache results with a 1-hour TTL and automatic pruning.

- **User Alerts**  
  Unsafe sites trigger a browser `alert()` for immediate user warning.

### 🧩 Key Components

| File/Folder            | Purpose                                                                 |
|------------------------|-------------------------------------------------------------------------|
| `content.js`           | Injected into every page, sanitizes URLs, checks status, triggers alert |
| `background.js`        | Handles Safe Browsing API requests and caching                          |
| `Popup.vue`            | Vue component for extension popup UI                                    |
| `storageUtils.js`      | Shared utilities for sanitization and storage                           |
| `vite.config.js`       | Vite configuration with multiple entry points for extension structure   |
| `public/`              | Extension assets, icons, fonts and tools for ML inference               |
| `public/sandbox`       | Sandbox to run ML inference                                             |

---

## 📄 License

This project is developed for educational purposes and is not production-ready. No formal license is applied. You are free to fork, adapt, and build upon this work for learning or academic use.
