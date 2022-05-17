// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var loadingProvider = _provInit();

StateProvider<bool>? _prov;

StateProvider<bool> _provInit() {
  _prov ??= StateProvider(
    (ref) {
      return false;
    },
  );

  return _prov!;
}

/// how to use:
/// wrap your body with `Loading`
///
/// when you want to start or stop loading,
/// call `Loading.load(context:context, ref:ref, true/false)`
class Loading extends StatelessWidget {
  static disposeLoading(WidgetRef ref) {
    try {
      ref.read(loadingProvider.notifier).state = false;
    } catch (e) {
      debugPrint('[LOADING LIBRARY] ' + e.toString());
    }
  }

  static load({
    required BuildContext context,
    required WidgetRef ref,
    required bool start,
  }) {
    _unfocus(context);
    try {
      ref.read(loadingProvider.notifier).state = start;
    } catch (e) {
      debugPrint('[LOADING LIBRARY] ' + e.toString());
    }
  }

  static _unfocus(BuildContext context) {
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

class _LoadingBuilder extends ConsumerStatefulWidget {
  const _LoadingBuilder({Key? key}) : super(key: key);

  @override
  ConsumerState<_LoadingBuilder> createState() => _LoadingBuilderState();
}

class _LoadingBuilderState extends ConsumerState<_LoadingBuilder> {
  @override
  void deactivate() {
    Loading.disposeLoading(ref);
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant _LoadingBuilder oldWidget) {
    Loading.disposeLoading(ref);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(loadingProvider);

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

class IsLoadingBuilder extends ConsumerWidget {
  final Widget Function(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) builder;

  const IsLoadingBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return builder(context, ref, isLoading);
  }
}
