import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IsLoadingBuilder(
          builder: (context, ref, isLoading) {
            return ElevatedButton(
              onPressed: () {
                Loading.load(context: context, ref: ref, start: !isLoading);
              },
              child: Text(isLoading ? 'Loading' : 'Load'),
            );
          },
        ),
      ),
      body: const Loading(
        child: Center(
          child: Text('aha'),
        ),
      ),
    );
  }
}
