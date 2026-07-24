import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get onStatusChanged =>
      _connectivity.onConnectivityChanged.map(_isConnected).distinct();

  Future<bool> get isConnected async =>
      _isConnected(await _connectivity.checkConnectivity());

  bool _isConnected(List<ConnectivityResult> results) =>
      !results.contains(ConnectivityResult.none);
}
