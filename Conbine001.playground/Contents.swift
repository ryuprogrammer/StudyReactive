import Foundation
import Combine

// -MARK: 最も簡単な例
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

// -MARK: 短縮系1
Just(999).sink { completion in
    switch completion {
    case .failure(let error):
        print(error.localizedDescription)
    case .finished:
        print("終了")
    }
} receiveValue: { value in
    print("受け取った値: \(value)")
}

// -MARK: 短縮系2
Just(777).sink(receiveValue: { value in
    print("簡単")
})


/// その２: オペレーター

//    // テストの点数
//    class TestResult {
//        var score: String
//        init(score: String) {
//            self.score = score
//        }
//    }
//
//    let testResult = TestResult(score: "0")
//
//    print("点数: \(testResult.score)")
//
//    let cancellable = Just(100)
//        /// オペレーター: publisherとsubscribe間で処理をする場合
//        /// 今回はInt型をString型にする
//        .map({ value in
//            return String(value)
//        })
//        .assign(to: \.score, on: testResult)
//
//    print("代入後の点数: \(testResult.score)")

extension Notification.Name {
    static let finishCalc = Notification.Name("finishCalc")
}

// テストの点数
class TestResult {
    var score: Int
    init(score: Int) {
        self.score = score
    }
}

let testResult = TestResult(score: 0)

print("点数: \(testResult.score)")

let cancellable = NotificationCenter.default.publisher(for: .finishCalc, object: nil)
    .map({ notification in
        return notification.userInfo?["result"] as? Int ?? 0
    })
    .assign(to: \.score, on: testResult)

// 採点処理

NotificationCenter.default.post(name: .finishCalc, object: nil, userInfo: ["result": 90])

print("代入後の点数: \(testResult.score)")
