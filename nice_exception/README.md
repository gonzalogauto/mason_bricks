# nice_exception

A brick to create nice exceptions using Freezed.

## How to use 🚀

```
mason make nice_exception --exception_name custom
```

## Variables ✨

| Variable         | Description                      | Default                 | Type      |
| ---------------- | -------------------------------- | ----------------------- | --------- |
| `exception_name` | The name of the exception        | custom                  | `string`  |
| `error_types`    | Exception error types            | [network,unauthorized]  | `array`   |


## Outputs 📦

```
--exception_name custom
── custom_exception.dart
── custom_exception.freezed.dart
```

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_exception.freezed.dart';

@freezed
class CustomException with _$CustomException implements Exception {
  const factory CustomException.otherError({
    required Object error,
    required StackTrace stacktrace,
  }) = _OtherError;
  
  const factory CustomException.networkError({
    @Default('NetworkError') String? message,
  }) = _NetworkError;
  
  const factory CustomException.unauthorizedError({
    @Default('UnauthorizedError') String? message,
  }) = _UnauthorizedError;
  
}
```

After you use it inside a repo or service you can handle all possible errors like this

```dart
void main(){
   try{
      yourRepoOrService.fetchSomeData();
   } on CustomException catch (e){
      e.when(
        networkError:(message)=>//handle this.
        unauthenticated:(message)=>//handle this.
        otherError:(error,stacktrace)=>//handle this.
      );
   }
}
```

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A new brick created with the Mason CLI.

_Generated by [mason][1] 🧱_

## Getting Started 🚀

This is a starting point for a new brick.
A few resources to get you started if this is your first brick template:

- [Official Mason Documentation][2]
- [Code generation with Mason Blog][3]
- [Very Good Livestream: Felix Angelov Demos Mason][4]

[1]: https://github.com/felangel/mason
[2]: https://github.com/felangel/mason/tree/master/packages/mason_cli#readme
[3]: https://verygood.ventures/blog/code-generation-with-mason
[4]: https://youtu.be/G4PTjA6tpTU
