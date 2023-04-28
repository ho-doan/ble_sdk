# Protobuf code generation

1. Install the newest `protoc`. It can be done via `brew`: 

```sh
brew install protobuf
```

2. For Swift code generation install :

```sh
brew install swift-protobuf
```

3. If you don't have Dart SDK on your computer please install it.

```sh
brew install dart
```

4. Run `pub global activate protoc_plugin`
5. OPTIONAL Add plugin path to `PATH` environment variable
6. Run the following command from the "protos" directory

```sh
protoc --dart_out=../lib/src/generated ./blesdk.proto
protoc --swift_out=../ios/Classes/BleData ./blesdk.proto
```

android:
 - add dependencies 
    implementation 'com.google.protobuf:protobuf-javalite:3.18.1'
 - add protobuf
    protobuf {
        protoc {
            artifact = 'com.google.protobuf:protoc:3.18.1'
        }

        generateProtoTasks {
            all().each { task ->
                task.builtins {
                    java {
                        option "lite"
                    }
                }
            }
        }
    }
 - add proguard
    consumerProguardFiles 'proguard-rules.txt'
    * -keep class com.hodoan.ble_sdk.** { *; }
 - add apply plugin
    apply plugin: 'com.google.protobuf'
 - add dependencies
    dependencies {
        ...
        classpath 'com.google.protobuf:protobuf-gradle-plugin:0.8.17'
    }
 - add sourceSets
    sourceSets {
        ...
        main {
            proto {
                srcDir '../protos/'
            }
        }
    }

 - make rebuild

NOTE: If directory `../lib/generated` or `./ios/Classes/BleData` does not exist please create it.
