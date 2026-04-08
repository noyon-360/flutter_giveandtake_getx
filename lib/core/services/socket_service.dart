import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../network/constants/api_constants.dart';

class SocketService {
  SocketService();

  io.Socket? _socket;

  io.Socket get socket {
    _socket ??= _createSocket();
    return _socket!;
  }

  bool get isConnected => _socket?.connected ?? false;

  void initialize() {
    if (_socket != null) return;
    _socket = _createSocket();
    _socket!.connect();
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }

  void joinNotification(String userId) {
    if (userId.trim().isEmpty) return;
    initialize();
    socket.emit('joinNotification', userId);
  }

  void joinRoom(String roomId) {
    if (roomId.trim().isEmpty) return;
    initialize();
    socket.emit('joinRoom', roomId);
  }

  void leaveRoom(String roomId) {
    if (roomId.trim().isEmpty) return;
    socket.emit('leaveRoom', roomId);
  }

  Stream<T> onEvent<T>(String event) {
    initialize();
    late StreamController<T> controller;
    void listener(dynamic data) {
      controller.add(data as T);
    }

    controller = StreamController<T>.broadcast(
      onListen: () => socket.on(event, listener),
      onCancel: () => socket.off(event, listener),
    );
    return controller.stream;
  }

  void on(String event, Function(dynamic) handler) {
    initialize();
    socket.on(event, handler);
  }

  void off(String event, [Function(dynamic)? handler]) {
    if (_socket == null) return;
    if (handler == null) {
      socket.off(event);
      return;
    }
    socket.off(event, handler);
  }

  io.Socket _createSocket() {
    return io.io(
      ApiConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .build(),
    );
  }
}
