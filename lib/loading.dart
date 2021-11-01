// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var loadingProvider = _provInit();

_provInit() => StateProvider(
      (ref) {
        return false;
      },
    );

/// how to use:
/// wrap your body with `Loading`
///
/// when you want to start or stop loading,
/// call `Loading.load(context, bool start)`
class Loading extends StatelessWidget {
  static disposeLoading(BuildContext context) {
    loadingProvider = null;
  }

  static init(BuildContext context) {
    loadingProvider ??= _provInit();
  }

  static load(BuildContext context, [bool b = true]) {
    _unfocus(context);
    try {
      context.read(loadingProvider).state = b;
    } catch (e) {
      print(e);
    }
  }

  static _unfocus(BuildContext context) {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      print(e);
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
    Loading.disposeLoading(context);
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant _LoadingBuilder oldWidget) {
    Loading.disposeLoading(context);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    Loading.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Loading.init(context);

    return Consumer(
      builder: (context, watch, child) {
        final isLoading = watch(loadingProvider).state;

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
  final Widget Function(BuildContext context, bool isLoading) builder;
  const IsLoadingBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final isLoading = watch(loadingProvider).state;
        return builder(context, isLoading);
      },
    );
  }
}
