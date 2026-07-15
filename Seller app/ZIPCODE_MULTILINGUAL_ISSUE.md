# Client Request & Reported Issues — Zipcodes / Multilingual Content

## 1. Zipcodes section must support 4 languages

**Context / how it's actually used:**
- In the Admin Panel there is a **Zipcodes** section.
- In the current system, the zipcode field is **not** used for real postal zipcodes — it is being used to add **areas under cities**.
- The admin enters the **area name** inside the zipcode field, and that area is linked under the selected city.

**What the client wants:**
- The Zipcodes section must also support the **four languages**:
  - English
  - Arabic
  - Hindi
  - Urdu
- The admin should be able to enter the **area/zipcode name in all four languages**.
- It should then **display correctly based on the selected app language**.

## 2. Multilingual products (Seller App) not translating in Customer App

**What the client tested:**
- Used the multilingual product feature from the **Seller App**.
- Added products and entered the **translations**.

**Issue noticed:**
- When the language is changed in the **Customer App**, the **product information does not change** to the selected language.

## 3. Admin Panel multilingual additions not translating in the app

**What the client tested:**
- Tested the multilingual additions from the **Admin Panel**.

**Issue noticed:**
- **None of them are translated** when the language is changed in the app.

## 4. Core request — check the full translation flow

- Please check the **full translation flow**, not only the input fields.
- The translations **can be added**, but they are **not displayed correctly** in the app after changing the language.
- So the problem is on the **display / output side**, not the data-entry side.

---

### Summary
The client reports that translations **can be saved** (both from the Seller App and the Admin Panel), but they are **never shown** in the app when the user switches language — the display/output side of the translation flow is broken. Additionally, the **Zipcodes** section (which is really used to add **areas under cities**) still needs to be made multilingual for **English, Arabic, Hindi, and Urdu**.
