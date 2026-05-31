import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../network/constants/api_constants.dart';
import '../network/services/auth_storage_service.dart';

class SocketService {
  SocketService();

  final AuthStorageService _authStorage = AuthStorageService();

  io.Socket? _socket;
  String? _authToken;
  Future<void>? _initFuture;

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  /// Lazily builds and connects the socket, sending the access token in the
  /// handshake auth payload (the backend rejects unauthenticated sockets).
  /// Idempotent and race-safe (memoised init future).
  Future<void> initialize() {
    return _initFuture ??= _doInitialize();
  }

  Future<void> _doInitialize() async {
    if (_socket != null) return;
    _authToken = await _authStorage.getAccessToken();
    _socket = _createSocket();
    _socket!.connect();
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
    _initFuture = null;
    _authToken = null;
  }

  void joinNotification(String userId) {
    if (userId.trim().isEmpty) return;
    initialize().then((_) => _socket?.emit('joinNotification', userId));
  }

  void joinRoom(String roomId) {
    if (roomId.trim().isEmpty) return;
    initialize().then((_) => _socket?.emit('joinRoom', roomId));
  }

  void leaveRoom(String roomId) {
    if (roomId.trim().isEmpty) return;
    _socket?.emit('leaveRoom', roomId);
  }

  Stream<T> onEvent<T>(String event) {
    late StreamController<T> controller;
    void listener(dynamic data) {
      controller.add(data as T);
    }

    controller = StreamController<T>.broadcast(
      onListen: () => initialize().then((_) => _socket?.on(event, listener)),
      onCancel: () => _socket?.off(event, listener),
    );
    return controller.stream;
  }

  void on(String event, Function(dynamic) handler) {
    initialize().then((_) => _socket?.on(event, handler));
  }

  void off(String event, [Function(dynamic)? handler]) {
    if (_socket == null) return;
    if (handler == null) {
      _socket!.off(event);
      return;
    }
    _socket!.off(event, handler);
  }

  io.Socket _createSocket() {
    final builder = io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .enableReconnection();

    // Backend requires a valid access token on the handshake (io.use).
    if (_authToken != null && _authToken!.isNotEmpty) {
      builder.setAuth({'token': _authToken});
    }

    return io.io(ApiConstants.socketUrl, builder.build());
  }
}
