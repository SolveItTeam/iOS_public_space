# Logger

Application debug menu and logger functionality package.
Depends on [Pulse library](https://github.com/kean/Pulse)

## Logs mechanism works in three modes:
- dev: log all events to console via OSLog + Pulse
- qa: log all events to console via OSLog + Pulse + Network events to Pulse
- release: log mechanism disabled

## How to use:
- Copy `Logger` package to your project
- Add `Logger` as local package to project
- Open `AppDelegate.swift`
- Add `import Logger` to top of the file
- Create private reference to `AppDebugConsolePlugin` inside your application delegate. For example: `private var consolePlugin: UIApplicationDelegate!`
- In `application(_ application: UIApplication, didFinishLaunchingWithOptions...)` method read value from `AppEnvironment.isEnabledDebugWindow`. If value is `true` — create instance of AppDebugConsolePlugin and store it in reference.
- Inside `application(_ application: UIApplication, didFinishLaunchingWithOptions...)` method call `consolePlugin.application(application, didFinishLaunchingWithOptions...)`
