//: [Previous](@previous)

import Foundation
import Combine

/*:
## Creating a complete publisher

This is much more complex and usually something you'll do
when combining existing publishers doesn't let you achieve
the desired result. Creating your own publishers this way
gives you complete control over the data flow and is much
more flexible, at the price of a non-trivial implementation.
*/

/*:
### Internal subscription

A publisher is usually an immutable structure
(with a few exceptions like `Publishers.Share`).

Therefore, all the work and mutability are handled by
the `Subscription` the publisher creates when you subscribe.
The first thing to do when creating a new publisher is preparing
this subscription. It usually is an internal (private) type,
since only the `Subscription` protocol is being exposed to the subscriber.
*/

fileprivate class FilterMapSubscription<Upstream, Downstream>: Subscription, Subscriber where Upstream: Publisher, Downstream: Subscriber, Upstream.Failure == Downstream.Failure {

	typealias Input = Upstream.Output
	typealias Failure = Upstream.Failure
	
	var downstream: Downstream
	var subscription: Subscription? = nil
	var pendingDemand: Subscribers.Demand = .none
	let filterMapClosure: (Upstream.Output) -> Downstream.Input?
	
	// MARK: Subscription protocol implementation
	
	init(upstream: Upstream, downstream: Downstream, closure: @escaping (Upstream.Output) -> Downstream.Input?) {
		self.downstream = downstream
		self.filterMapClosure = closure
		upstream.subscribe(self)
	}

	func request(_ demand: Subscribers.Demand) {
		if let subscription = subscription {
			subscription.request(demand)
		} else {
			self.pendingDemand += demand
		}
	}
	
	func cancel() {
		pendingDemand = .none
		subscription?.cancel()
	}
	
	// MARK: Subscriber protocol implementation
	
	func receive(subscription: Subscription) {
		self.subscription = subscription
		if pendingDemand != .none {
			subscription.request(pendingDemand)
		}
	}
	
	func receive(_ input: Upstream.Output) -> Subscribers.Demand {
		if let result = filterMapClosure(input) {
			return downstream.receive(result)
		}
		return .none
	}

	func receive(completion: Subscribers.Completion<Upstream.Failure>) {
		downstream.receive(completion: completion)
		subscription = nil
	}
	
}

/*:
### Publisher immutable structure

The publisher never changes. Every time a subscriber subscribes to it,
it creates a new `Subscription` (in this case, the private `FilterMapSubscription`)
and hands it over to the subscriber.
*/

struct FilterMap<T, Upstream>: Publisher where Upstream: Publisher {
	typealias Output = T
	typealias Failure = Upstream.Failure
	
	let filterClosure: (Upstream.Output) -> T?
	let upstream: Upstream
	
	init(upstream: Upstream, _ closure: @escaping (Upstream.Output) -> T?) {
		self.upstream = upstream
		self.filterClosure = closure
	}
	
	func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, T == S.Input {
		subscriber.receive(subscription: FilterMapSubscription(upstream: upstream,
															   downstream: subscriber,
															   closure: filterClosure))
	}
}

/*:
### `Publisher` instance extension function

To make the new operator easy to use, create an extension function for `Publisher`
instances which lets you easily chain this with other publishers.
*/

extension Publisher {
	func filterMap<T>(_ closure: @escaping (Output) -> T?) -> FilterMap<T,Self> {
		FilterMap(upstream: self, closure)
	}
}


/*:
### Example of use

Filter odd values and, at the same time,
turn the values we keep into strings
*/

let subscription = [1,2,3,4,5,6]
	.publisher
	.filterMap { value -> String? in
		((value & 1) == 0) ? "Even value: \(value)" : nil
}
.sink {
	print($0)
}
