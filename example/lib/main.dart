import 'package:flutter/material.dart';
import 'package:loading/loading.dart';

void main() {
  runApp(const MyApp());
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
          builder: (context, isLoading, _) {
            return ElevatedButton(
              onPressed: () {
                if (isLoading) {
                  Loading.unload(context);
                } else {
                  Loading.load(context);
                }
              },
              child: Text(isLoading ? 'Unload' : 'Load'),
            );
          },
        ),
      ),
      body: const Loading(
        child: Center(
          child: Text('wow cool package dude 😳'),
        ),
      ),
    );
  }
}
