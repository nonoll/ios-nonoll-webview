import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
  
  private var webView: WKWebView!
  
  // TODO: URL 변경
  let urlString = "https://www.apple.com"
  
  // TODO: [Swift -> JS] - JS 추가 후 이름 변경
  let jsFileName = "Nonoll"
  
  // TODO: [JS -> Swift] - Handler 배열로 추가
  // ex : window.webkit.messageHandlers.nonollMessage.postMessage('Hello WebKit');
  let handlerFromJS = ["nonollMessage"]
  
  override func loadView() {
    self.webView = WKWebView(frame: .zero, configuration: self.webViewConfiguration())
    self.webView.uiDelegate = self
    self.view = self.webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.webView.uiDelegate = self
    guard let url = URL(string: self.urlString) else { return }
    let request = URLRequest(url: url)
    self.webView.load(request)
  }
  
  private func loadJS() -> String? {
    guard let path = Bundle.main.path(forResource: self.jsFileName, ofType: "js") else {
      return nil
    }
    var content = ""
    do {
      content = try String(contentsOfFile: path)
    } catch let error {
      print(error)
      return nil
    }
    return content
  }
  
  private func webViewConfiguration() -> WKWebViewConfiguration {
    let configuration = WKWebViewConfiguration()
    
    let contentController = WKUserContentController()
    if let content = self.loadJS() {
      let userScript = WKUserScript(source: content, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
      contentController.addUserScript(userScript)
    }
    self.addHandler(contentController: contentController)
    configuration.userContentController = contentController
    webView = WKWebView(frame: .zero, configuration: configuration)
    return configuration
  }
  
  private func addHandler(contentController: WKUserContentController) {
    handlerFromJS.forEach {
      contentController.add(self, name: $0)
    }
  }
  
}

extension ViewController: WKScriptMessageHandler {
  
  // TODO: 메세지에 따라 동작 수정하시려면 여기서 수정
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    handlerFromJS.forEach {
      if message.name == $0 {
        print("message.name : \(message.name)\nmessage.body : \(message.body)")
      }
    }
  }
  
}
