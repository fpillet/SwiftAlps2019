//: [Previous](@previous)

import Foundation
import Combine

/*:
[Previous](@previous)
# Combining publishers
`CombineLatest` allows to
- merge multiple streams into one
- listen to multiple publishers

More operators like `switchLatest`, `merge`, `Publishers.MergeMany` and `zip` allow you to operate on multiple upstream publishers at the same time.
*/

//: **simulate** input from text fields with subjects
let usernamePublisher = PassthroughSubject<String, Never>()
let passwordPublisher = PassthroughSubject<String, Never>()

//: **combine** the latest value of each input to compute a validation
let validatedCredentials = Publishers.CombineLatest(usernamePublisher, passwordPublisher)
    .map { (username, password) -> Bool in
        !username.isEmpty && !password.isEmpty && password.count > 12
    }
    .sink { (valid) in
        print("CombineLatest: are the credentials valid? \(valid)")
    }

//: Example: simulate typing a username and the password twice
usernamePublisher.send("avanderlee")
passwordPublisher.send("weakpass")
passwordPublisher.send("verystrongpassword")

//: [Next](@next)
