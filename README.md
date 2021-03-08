# ios-nonoll-webview

## JS -> Swift
- handlerFromJS 배열에 이름 지정 후 JS에서 호출

#### 예제
Swift에서
`let handlerFromJS = ["nonollMessage"]`

JS에서
`window.webkit.messageHandlers.nonollMessage.postMessage('Hello WebKit');`


## Swift -> JS
- Nonoll.js 파일 내에 코드 작성
