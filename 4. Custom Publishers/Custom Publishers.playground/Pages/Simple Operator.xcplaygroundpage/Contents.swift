//: [Previous](@previous)

import Foundation
import Combine

/*:
## Reusing existing publishers

This is the simplest form of implementation for an operator. It only reuses and
combines existing operators, and is therefore limited to using the available operators.

The only challenge is getting the types right in various cases inside our implementation.
Since Combine is so strongly typed, we often have to `eraseToAnyPublisher()`,
in particular every time we need to return different types
*/

extension Publisher {
	func filterMap<T>(_ closure: @escaping (Output) -> T?) -> AnyPublisher<T,Failure> {
		self.flatMap { value -> AnyPublisher<T, Failure> in
			if let result = closure(value) {
				// `Just` never fails, so we need to add `setFailureType` to make the
				// signature match the expected return signature
				return Just(result)
					.setFailureType(to: Failure.self)
					.eraseToAnyPublisher()
			}
			return Empty<T,Failure>().eraseToAnyPublisher()
		}
		.eraseToAnyPublisher()
	}
}

// Example usage: filter odd values and, at the same time,
// turn the values we keep into strings
let subscription = [1,2,3,4,5,6]
	.publisher
	.filterMap { value -> String? in
		((value & 1) == 0) ? "Even value: \(value)" : nil
}
.sink {
	print($0)
}


//: [Next](@next)
