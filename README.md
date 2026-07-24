# Supermarket Tracker

Base Flutter do Supermarket Tracker, organizada em Clean Architecture, Feature First,
MVVM, Riverpod e GetIt. Esta fase não contém telas ou regras de negócio.

## Ambientes

O ambiente é definido por `--dart-define=FLAVOR=<dev|homolog|prod>` e carrega o
arquivo correspondente em `assets/config`. No Android, use também o flavour nativo:

```bash
flutter run --flavor dev --dart-define=FLAVOR=dev
flutter run --flavor homolog --dart-define=FLAVOR=homolog
flutter run --flavor prod --dart-define=FLAVOR=prod
```

No iOS, os arquivos de ambiente estão em `ios/Flutter/Config`; conecte cada um a
um Scheme/Build Configuration no Xcode e mantenha o mesmo `--dart-define`.

## Estrutura

`lib/core` abriga serviços compartilhados. `lib/app` contém bootstrap, DI, roteador,
tema e internacionalização. Cada feature futura deve seguir `data`, `domain` e
`presentation` (com `viewmodels`, widgets e use cases), como o molde em
`lib/features/_shared`.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
