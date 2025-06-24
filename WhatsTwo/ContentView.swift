import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        WebView()
            .ignoresSafeArea()
    }
}

struct WebView: View {
    @StateObject private var webViewStore = WebViewStore()
    @Environment(\.colorScheme) var colorScheme
    @State private var showingClearDataAlert = false
    
    var body: some View {
        ZStack {
            // Background color based on color scheme
            Rectangle()
                .fill(colorScheme == .dark ? 
                      Color(red: 0x16/255, green: 0x17/255, blue: 0x17/255) : 
                      Color(red: 0xf7/255, green: 0xf5/255, blue: 0xf3/255))
                .ignoresSafeArea()
            
            // WebView (full screen)
            WebViewWrapper(webView: webViewStore.webView)
                .onAppear {
                    webViewStore.loadWhatsApp()
                }
            
            // Floating toolbar (bottom right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        // Refresh button
                        Button(action: {
                            webViewStore.refresh()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(.black.opacity(0.7), in: Circle())
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    showingClearDataAlert = true
                                }
                        )
                        
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 50)
            }
        }
        .alert("Clear Session Data", isPresented: $showingClearDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                webViewStore.hardRefresh()
            }
        } message: {
            Text("This will clear all cookies, login data, and session information. You'll need to scan the QR code again.")
        }
    }
}

class WebViewStore: ObservableObject {
    lazy var webView: WKWebView = createWebView()
    
    private func createWebView() -> WKWebView {
        let config = WKWebViewConfiguration()
        
        // Use persistent data store to maintain session
        config.websiteDataStore = WKWebsiteDataStore.default()
        
        // Enable JavaScript
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        
        #if os(iOS)
        // Disable scrolling and set viewport (iOS only)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        #endif
        
        return webView
    }
    
    func loadWhatsApp() {
        guard let url = URL(string: "https://web.whatsapp.com") else { return }
        let request = URLRequest(url: url)
        print("Loading WhatsApp Web...")
        webView.load(request)
    }
    
    func refresh() {
        webView.reload()
    }
    
    func hardRefresh() {
        // Clear all website data from the default data store
        WKWebsiteDataStore.default().removeData(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
            modifiedSince: Date.distantPast
        ) { [weak self] in
            DispatchQueue.main.async {
                // Also clear any cached data from the webview itself
                self?.webView.configuration.websiteDataStore.removeData(
                    ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                    modifiedSince: Date.distantPast
                ) { [weak self] in
                    DispatchQueue.main.async {
                        self?.loadWhatsApp()
                    }
                }
            }
        }
    }
}

#if os(iOS)
struct WebViewWrapper: UIViewRepresentable {
    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No zoom scaling needed
    }
}
#endif

#if os(macOS)
struct WebViewWrapper: NSViewRepresentable {
    let webView: WKWebView
    
    func makeNSView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // macOS doesn't need zoom scaling
    }
}
#endif