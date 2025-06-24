# WhatsTwo

<p align="center">
  <img src="WhatsTwo/Assets.xcassets/AppIcon.appiconset/icon-1024.png" alt="WhatsTwo Icon" width="200" height="200">
</p>

A native macOS and iOS app that provides a dedicated desktop experience for WhatsApp Web. WhatsTwo wraps WhatsApp Web in a clean, persistent interface that maintains your login session across app launches.

## Features

- **Native Experience**: Built with SwiftUI for smooth macOS and iOS integration
- **Persistent Sessions**: Stay logged in between app launches
- **Clean Interface**: Distraction-free WhatsApp experience without browser tabs
- **Cross-Platform**: Works on both Mac and iPhone/iPad
- **Session Management**: Easy session clearing with long-press refresh

## Requirements

- macOS or iOS 18.5+
- Xcode 16.4+ (for development)

## Development

Open `WhatsTwo.xcodeproj` in Xcode and run the project. The app will load WhatsApp Web in a dedicated WebView with persistent data storage.

## Architecture

Built with SwiftUI and WebKit, using cross-platform code to support both macOS and iOS with platform-specific optimizations for each environment.