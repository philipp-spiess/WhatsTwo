# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

WhatsTwo is a native macOS/iOS SwiftUI application that provides a desktop wrapper for WhatsApp Web. It loads `https://web.whatsapp.com` in a WKWebView with persistent session management.

## Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI with WebKit (WKWebView)
- **Platforms**: iOS 18.5+ and macOS
- **Build Tool**: Xcode 16.4+

## Development Commands

### Building and Running
- **Build**: Use Xcode's Product → Build (`⌘+B`)
- **Run**: Use Xcode's Product → Run (`⌘+R`) 
- **Archive**: Use Xcode's Product → Archive for distribution

### Testing
- Test on iOS Simulator for iOS behavior
- Test on macOS directly for desktop experience
- No unit test framework currently configured

## Architecture

### Core Structure
- `WhatsTwoApp.swift`: Main app entry point using `@main`
- `ContentView.swift`: Primary UI containing WebView wrapper with cross-platform implementations
- `WebViewStore`: ObservableObject managing WKWebView state and navigation

### Cross-Platform Pattern
The app uses conditional compilation with separate `UIViewRepresentable` (iOS) and `NSViewRepresentable` (macOS) implementations in the same file. When modifying WebView behavior, always update both platform implementations.

### WebView Management
- Persistent data store maintains WhatsApp sessions across app launches
- Custom User-Agent ensures WhatsApp Web compatibility
- Session clearing available via long-press on refresh button

## Key Files

- `WhatsTwo.entitlements`: App sandbox permissions - be cautious when modifying as it affects security and app store approval
- `Assets.xcassets/AppIcon.appiconset/`: App icons for different platforms and sizes
- Platform-specific code sections marked with `#if os(iOS)` and `#if os(macOS)`

## Development Notes

### SwiftUI Patterns
- Uses `@StateObject` for WebViewStore management
- Implements proper memory management with `[weak self]` in WKWebView closures
- Follows MVVM pattern with observable data store

### App Permissions
The app requires specific entitlements for:
- Network client access (for WhatsApp Web)
- File system access (for downloads)
- App Sandbox compliance

### Platform Differences
- iOS version disables scroll bouncing for native app feel
- macOS version includes proper window management
- Both share core WebView functionality but have platform-specific UI adaptations

## Common Tasks

When adding features:
1. Consider both iOS and macOS implementations
2. Test WebView behavior on both platforms
3. Maintain session persistence functionality
4. Follow existing SwiftUI observable pattern for state management