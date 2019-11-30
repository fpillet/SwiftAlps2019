import Foundation
import Combine

/*:
# Custom publishers

Writing a custom publisher can be done using one of two methods:
- by reusing existing publishers and combining them into a single publisher
- by creating a new, complete `Publisher` struct (or class) along with a custom `Subscription`

We want to have a single publisher that combines both `filter` and `map` publishers.
We're going to implement this operator in both ways so as to demonstrate the difference in implementation.

*/

//: [Next](@next)
