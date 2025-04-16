# 💱 Currency Exchange Rate App

This is a SwiftUI-based iOS application that displays live and historical currency exchange rates using data from [exchangerate.host](https://exchangerate.host/documentation). The project showcases modular app architecture with MVVM+C, Clean Architecture principles, and modern concurrency using `async/await`.

---

## 🚀 Features

- Live exchange rate updates for selected currency pairs
- Historical data support
- Multi-currency selection screen
- Persistent storage using **SwiftData**
- Periodic auto-refresh (simulated or real)
- Onboarding flow to demonstrate Coordinator-based navigation
- Basic error handling for failed network calls

---

## 🧱 Architecture

- **MVVM+C** (Model-View-ViewModel + Coordinator)
- **Clean Architecture**
  - `UseCases`
  - `Repositories`
  - `RemoteDataSources` / `LocalDataSources`
  - `DIContainer`
- **SwiftUI** for UI
- **Combine** for publishers/subscribers
- **SwiftData** for persistence
- **async/await** for asynchronous logic

---

## 🔌 API Integration

Data is fetched from [https://exchangerate.host](https://exchangerate.host/documentation). Two endpoints are used:

1. **Live Exchange Rates**  
   `https://api.exchangerate.host/live`

2. **Historical Exchange Rates**  
   `https://api.exchangerate.host/historical`

Due to API limitations, live data is updated only **once every 60 minutes**. Therefore, frequent real-time updates (e.g., every 3-5 seconds) are **not possible** using the real API.

To demonstrate UI updates, a **simulation mode** is enabled by default.

---

## ⚙️ Configuration

App uses the flag:

```swift
AppConstants.Flags.isSimulationMode = true
```

- `true` (default): Simulates random rate changes every 5 seconds
- `false`: Fetches real data from exchangerate.host (updated hourly)

You can switch this value in `AppConstants.swift`.

---

## 💾 Persistence

- Selected currencies are saved locally using **SwiftData**
- Deletion or addition is persisted across app launches

---

## 📲 Setup Instructions

1. Clone the repository
2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode 15+
3. Run on iOS 17+ simulator or device

---

## 🔍 Assumptions

- Live currency rates are fetched only if `isSimulationMode` is `false`
- Currencies are sorted by `pair` for consistent display
- All timestamps are shown in the device's current locale and timezone

---

## 🧪 Screenshots

<img width="362" alt="Screenshot 2025-04-16 at 21 37 43" src="https://github.com/user-attachments/assets/168b30bc-3bbb-4ae3-a150-ba085075a7c3" />
<img width="362" alt="Screenshot 2025-04-16 at 21 37 49" src="https://github.com/user-attachments/assets/aec49914-396a-4881-bbde-fb28d05f09c7" />
<img width="362" alt="Screenshot 2025-04-16 at 21 37 52" src="https://github.com/user-attachments/assets/dd63ca8b-5c30-4508-a4be-444d5a9d84f3" />
<img width="362" alt="Screenshot 2025-04-16 at 21 38 02" src="https://github.com/user-attachments/assets/53276407-fa30-4e7c-ac60-6a03de23795d" />
<img width="362" alt="Screenshot 2025-04-16 at 21 38 08" src="https://github.com/user-attachments/assets/74cd41b2-d474-4ccf-b83d-3738e5761652" />

---

## ✍️ Observations & Notes

- Coordinator-based flow ensures clean navigation separation
- The onboarding screen is included to demonstrate transitions between flows
- Using SwiftData simplifies local persistence compared to CoreData for small datasets
- The simulation mode allows showcasing real-time diff updates without API limitations
- Error handling currently includes basic user-facing feedback.

---

## 📦 Dependencies

None – no external libraries used.

---
