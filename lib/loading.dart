// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

final _loadingNotifier = ValueNotifier(false);

/// how to use:
/// wrap your body with `Loading`
///
/// when you want to start loading:
/// call `Loading.load(context:context)`
///
/// when you want to stop loading:
/// call `Loading.unload(context:context)`
class Loading extends StatelessWidget {
  static load([BuildContext? context]) {
    return _load(
      context: context,
      start: true,
    );
  }

  static unload([BuildContext? context]) {
    return _load(
      context: context,
      start: false,
    );
  }

  static _load({
    BuildContext? context,
    required bool start,
  }) {
    _unfocus(context);
    try {
      _loadingNotifier.value = start;
    } catch (e) {
      debugPrint('[LOADING LIBRARY] ' + e.toString());
    }
  }

  static _unfocus([BuildContext? context]) {
    if (context == null) return;

    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      debugPrint('[LOADING LIBRARY] ' + e.toString());
    }
  }

  final Widget child;

  /// wether to unfocus on tapping
  /// anywhere
  final bool unfocusOnTap;

  const Loading({
    required this.child,
    this.unfocusOnTap = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (unfocusOnTap) {
          Loading._unfocus(context);
        }
      },
      child: Stack(
        children: [
          child,
          const _LoadingBuilder(),
        ],
      ),
    );
  }
}

class _LoadingBuilder extends StatefulWidget {
  const _LoadingBuilder({Key? key}) : super(key: key);

  @override
  State<_LoadingBuilder> createState() => _LoadingBuilderState();
}

class _LoadingBuilderState extends State<_LoadingBuilder> {
  @override
  void deactivate() {
    _loadingNotifier.value = false;
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant _LoadingBuilder oldWidget) {
    _loadingNotifier.value = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loadingNotifier,
      builder: (context, isLoading, child) {
        if (!isLoading) {
          return Container();
        }

        return Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Opacity(
            opacity: .7,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}

class IsLoadingBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isLoading,
    Widget? child,
  ) builder;

  final Widget? child;

  const IsLoadingBuilder({
    required this.builder,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loadingNotifier,
      builder: builder,
      child: child,
    );
  }
}
