// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore: constant_identifier_names

import 'package:rxdart/rxdart.dart';

const String defaultIdentifier = "eventbus_youdu";

///class for to share information with another page

class Bus {
  PublishSubject _subjects = PublishSubject();

  String _tag = "";

  PublishSubject get subject => _subjects;

  String get tag => _tag;

  Bus(String tag) {
    _tag = tag;
    _subjects = PublishSubject();
  }

  Bus.create() {
    _subjects = PublishSubject();
    _tag = defaultIdentifier;
  }

  void dispose() {
    _subjects.close();
  }
}

class RxBus {
  static final RxBus _singleton = RxBus._internal();

  factory RxBus() {
    return _singleton;
  }

  RxBus._internal();

  static final List<Bus> _list = <Bus>[];

  static RxBus get singleton => _singleton;

  static Stream<T> register<T>({required String tag}) {
    Bus _eventBus;
    if (_list.isNotEmpty) {
      _list.forEach((bus) {
        if (bus.tag == tag) {
          _eventBus = bus;
          return;
        }
      });
      _eventBus = Bus(tag);
      _list.add(_eventBus);
    } else {
      _eventBus = Bus(tag);
      _list.add(_eventBus);
    }
    return _eventBus.subject.stream.where((event) => event is T).cast<T>();
  }

  static void post(event, {tag}) {
    for (var rxBus in _list) {
      if (tag != null && tag != defaultIdentifier && rxBus.tag == tag) {
        rxBus.subject.sink.add(event);
      } else if ((tag == null || tag == defaultIdentifier) && rxBus.tag == defaultIdentifier) {
        rxBus.subject.sink.add(event);
      }
    }
  }

  static void destroy({tag}) {
    var toRemove = [];
    for (var rxBus in _list) {
      if (tag != null && tag != defaultIdentifier && rxBus.tag == tag) {
        rxBus.subject.close();
        toRemove.add(rxBus);
      } else if ((tag == null || tag == defaultIdentifier) && rxBus.tag == defaultIdentifier) {
        rxBus.subject.close();
        toRemove.add(rxBus);
      }
    }
    for (var rxBus in toRemove) {
      _list.remove(rxBus);
    }
  }
}
