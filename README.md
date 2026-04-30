# 🚀 Flutter Network Monitor (Real Internet Checker)

A professional, robust, and clean way to monitor **real internet connectivity** in Flutter.

Unlike standard solutions, this utility verifies **actual internet access** (via DNS lookup) instead of just checking whether Wi-Fi or Mobile Data is enabled.

---

## 🧐 Why use this?

The `connectivity_plus` package only detects **network interface status**.

👉 Meaning:
- You might be connected to Wi-Fi ❌  
- But **no real internet access** (router issue, expired data, etc.)

💡 This package solves that by:
- Validating connectivity against a **real-world host**
- Making your app truly **Network Aware**

---

## ✨ Features

- 🔍 **Real Internet Validation**  
  Uses DNS lookup instead of fake connectivity signals.

- 🧱 **Clean Architecture Ready**  
  Built using Dependency Inversion Principle (DIP).

- 🔁 **Singleton Pattern**  
  One instance across the whole app.

- ⚡ **Reactive (Stream-based)**  
  Uses `.distinct()` to prevent unnecessary rebuilds.

- 🧩 **Zero Boilerplate**  
  Plug & play with `NetworkAware` mixin.

---

## 🛠 Installation

Add the dependency:

```yaml
dependencies:
  connectivity_plus: ^6.0.0
```

Then add your file:

```
lib/core/network/network_info.dart
```

---

## 🚀 Usage

### 1️⃣ Using the Mixin (Recommended)

```dart
class MyRepository with NetworkAware {

  Future<void> uploadData() async {
    if (await isConnected) {
      print("Sending data...");
    } else {
      print("No real internet access!");
    }
  }
}
```

---

### 2️⃣ Real-time Monitoring

```dart
StreamBuilder<bool>(
  stream: NetworkMonitor().connectivityStream,
  builder: (context, snapshot) {
    final isOnline = snapshot.data ?? true;

    return isOnline
        ? const Text("You are Online")
        : const Text("Offline Mode");
  },
);
```

---

### 3️⃣ Direct Access (Singleton)

```dart
final hasInternet = await NetworkMonitor().isConnected;
```

---

## 🏗 Architecture

### 🔹 Abstraction

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
}
```

---

### 🔹 Implementation

```dart
class NetworkMonitor implements NetworkInfo {
  // Singleton implementation
}
```

---

## 💡 Design Decisions

- **DIP Compliant** → Easy testing & mocking  
- **Singleton Pattern** → Avoid multiple instances  
- **Timeout Handling** → Prevent hanging on weak networks  
- **Stream Optimization** → `.distinct()` avoids unnecessary rebuilds  

---

## 📦 Use Cases

- Show **No Internet Banner**
- Prevent API calls when offline
- Enable **Offline Mode**
- Retry failed requests intelligently

---

## 👨‍💻 Author

**Abdelrhman Mohamed Mahrous**  
Flutter Developer | Turning ideas into modern, scalable mobile apps — from concept to store launch

