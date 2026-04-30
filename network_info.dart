// Import necessary packages for connectivity status and internet address lookup
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

// Abstract class defining the contract for network information
abstract class NetworkInfo {
  // Checks for real internet access (pinging a server)
  Future<bool> get isConnected; 
  // Checks if the device is connected to a network (WiFi/Mobile) regardless of internet access
  Future<bool> get hasNetwork;  
  // Stream to listen for real-time changes in internet connectivity
  Stream<bool> get connectivityStream; 
}

// Implementation of NetworkInfo using a Singleton pattern
class NetworkMonitor implements NetworkInfo {
  // Private static instance for Singleton pattern
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  // Factory constructor to return the same instance every time
  factory NetworkMonitor() => _instance;
  // Internal private constructor
  NetworkMonitor._internal();

  // Instance of the Connectivity plugin
  final Connectivity _connectivity = Connectivity();

  @override
  // Checks if there is any active network interface (WiFi, Mobile, etc.)
  Future<bool> get hasNetwork async {
    final result = await _connectivity.checkConnectivity();
    // In newer versions, checkConnectivity returns a List
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  @override
  // Validates actual internet access by performing a DNS lookup
  Future<bool> get isConnected async {
    if (!await hasNetwork) return false;

    try {
      // Lookup google.com to verify real world connectivity
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      // If DNS lookup fails, there is no real internet
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  // Maps connectivity changes to a boolean stream of actual internet status
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.asyncMap((_) async {
      return await isConnected;
    }).distinct(); // Prevents emitting duplicate values
  }
}

// Mixin to easily provide network status to any class (e.g., ViewModels or UI)
mixin NetworkAware {
  // Provides access to the NetworkMonitor instance
  NetworkInfo get networkInfo => NetworkMonitor();

  // Short-hand getter to check current connection status
  Future<bool> get isConnected => networkInfo.isConnected;
}