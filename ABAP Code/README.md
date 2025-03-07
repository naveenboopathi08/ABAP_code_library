### **📌 README: SAP ABAP - Dynamic Requested Delivery Date Handling**  

#### **🚀 Project Overview**  
This SAP ABAP code dynamically updates the **Requested Delivery Date (RDD)** in **Sales Orders (SO)** based on the order creation time. The logic ensures that RDD is correctly calculated while handling **holidays, weekends, and system constraints**.  

---

#### **🔹 Requirement**  
- The SO is created via **RFC**, using the **BAPI_SALESORDER_CREATEFROMDAT2**.  
- By default, the RDD was **same as the SO creation date**, which needed to be adjusted dynamically:  
  - **Orders before 1 PM** → **RDD = Next Working Day**  
  - **Orders after 1 PM** → **RDD = Day After Tomorrow (Next Working Day)**  
  - **Thursday after 1 PM** → **RDD = Monday (Skipping Weekend)**  
  - **Friday before 1 PM** → **RDD = Monday**  
  - **Friday after 1 PM** → **RDD = Tuesday**  
  - **Saturday & Sunday Orders** → **RDD Adjusted to Next Business Day**  

---

#### **🔹 Key Challenges & Solutions**  
✅ **User Exit Triggers Twice**:  
- The user exit was called **twice during SO creation**, causing the date to be updated incorrectly.  
- **Solution:** Used **ABAP Memory (`IMPORT/EXPORT MEMORY ID`)** to ensure the logic executes **only once per transaction**.  

✅ **Handling VA02 (Change Order) & VA03 (Display Order)**:  
- Initially, the date was getting modified when users opened VA02/VA03.  
- **Solution:** Added **`IF sy-tcode NOT IN ('VA02', 'VA03')`** condition to prevent unnecessary changes.  

✅ **Factory Calendar Consideration**:  
- The RDD should **skip non-working days (holidays & weekends)**.  
- **Solution:** Used **`DATE_CONVERT_TO_FACTORYDATE`** to ensure the final date is always a valid working day.  

✅ **Code Optimization**:  
- Used **SWITCH** and **COND** instead of long `IF` conditions for cleaner logic.  
- Replaced `STATICS` with **ABAP Memory** to persist execution state across function calls.  

---

#### **📂 Key Components**
| **Component**  | **Description** |
|---------------|----------------|
| **User Exit**  | Implemented in `USEREXIT_MOVE_FIELD_TO_VBAK` to modify RDD |
| **Factory Calendar**  | `DATE_CONVERT_TO_FACTORYDATE` ensures valid working days |
| **Memory Management** | `IMPORT/EXPORT MEMORY ID` used to handle multiple calls |
| **Performance Optimizations** | `SWITCH`, `COND`, and structured logic used |

---

#### **🛠️ How to Use**  
1️⃣ **Implement the Code** in the relevant **user exit include** (inside `USEREXIT_MOVE_FIELD_TO_VBAK`).  
2️⃣ **Ensure RFC Calls Follow This Logic** when creating SO.  
3️⃣ **Test Various Scenarios** including **weekends, cut-off time, and holidays**.  
4️⃣ **Deploy & Monitor** for any system-specific edge cases.  

---

#### **📞 Need Help?**  
feel free to **raise an issue or reach out!** 🚀  
