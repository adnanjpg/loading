This is a library I've made to easily integrate a loading spinner over any page, mostly used in forms.

## how to integrate into your project
this is not a good enough thing to be published on [pub.dev](https://www.pub.dev), so I'll keep it on github.

you can add it to your `pubspec.yaml` in 2 ways:
<details>
    <summary>if you're using ssh</summary>

    loading:
        git: git@github.com:adnanjpg/loading.git
</details>
<details>
    <summary>if you're not using ssh</summary>

    loading:
        git: https://github.com/adnanjpg/loading.git
</details>

## usage

1. wrap your page you want to be loading with a  `Loading`
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: ...,
    body: Loading(
      // this adds a functionality where 
      // the keyboard disappears when the
      // user taps out of a textfield
      unfocusOnTap: ...,
      child: ...,
    ),
  );
}
```

2. if you want to show the overlay spinner, call `Loading.load(context)`

3. if you want to hide the overlay spinner, call `Loading.unload(context)`

4. now if you want to do something depending on wether the spinner is visible or not, use `IsLoadingBuilder`
```dart
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
```

5. you can check the [example app](example/lib/main.dart) for a full example