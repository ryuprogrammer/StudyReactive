import Foundation
import Combine

// 整数型の値を出力するパブリッシャー
let publisher = Just(100)

// 整数の値を受け取るサブスクライバー
// valueにpublisherが出力した値が渡ってくる
// receiveCompletion: publisherがどういう状態で終わったか渡してくれる
let subscriber = Subscribers.Sink<Int, Never>(receiveCompletion: { completion in
    switch completion {
    case .failure(let error):
        print(error.localizedDescription)
    case .finished:
        print("終了")
    }
}, receiveValue: { value in
    print("受け取った値: \(value)")
})

// ↑を関連付ける必要がある。（定義しただけだから）

// publisherが出力した値をsubscriberで受け取ることができる
publisher.subscribe(subscriber)
