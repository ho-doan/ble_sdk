# flutter pub global deactivate protoc_plugin
# flutter pub global activate protoc_plugin
dart pub global activate protoc_plugin
export PATH="$PATH":"$HOME/.pub-cache/bin"
protoc --dart_out=../lib/src/generated ./blesdk.proto
protoc --swift_out=../ios/Classes/BleData ./blesdk.proto