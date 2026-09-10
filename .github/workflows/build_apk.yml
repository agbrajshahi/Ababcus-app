name: Build Android APK
on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
      - run: |
          cat << 'EOF' > pubspec.yaml
          name: abacus_app
          description: Abacus Flash Math
          publish_to: 'none'
          version: 1.0.0+1
          environment:
            sdk: '>=3.0.0 <4.0.0'
          dependencies:
            flutter:
              sdk: flutter
            cupertino_icons: ^1.0.2
          flutter:
            uses-material-design: true
          EOF
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v4
        with:
          name: my-abacus-app
          path: build/app/outputs/flutter-apk/app-release.apk
