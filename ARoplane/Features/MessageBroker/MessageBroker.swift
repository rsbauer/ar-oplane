//
//  MessageBroker.swift
//  ABCNews
//
//  Created by Bauer, Robert S. on 5/17/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import UIKit

// Pub/Sub pattern using a singleton
// From: http://everythingel.se/blog/publish-subscribe-in-swift/

private let _messageBroker = MessageBroker()
public typealias MessageKey = String

// Protocols

public protocol Message { func messageKey() -> MessageKey }
public protocol Subscriber { func receive(_ message: Message) }

public class MessageBroker: NSObject {
	
	class var sharedMessageBroker: MessageBroker {
		return _messageBroker
	}
	
	fileprivate var subscribers = [MessageKey: [Weak<AnyObject>]]()

	func unsubscribe(_ subscriber: Subscriber, messageKey: MessageKey) {
		if subscribers[messageKey] == nil {
			return
		}
		
		let item = subscriber as AnyObject
		if let index = subscribers[messageKey]?.index(where: { $0.value === item }) {
			subscribers[messageKey]?.remove(at: index)
		}
	}
	
	func subscribe(_ subscriber: Subscriber, messageKey: MessageKey) {
		if subscribers[messageKey] == nil {
			subscribers[messageKey] = []
		}
		
		subscribers[messageKey]?.append(Weak(value: subscriber as AnyObject))
	}
	
	func publish(_ message: Message) {
		guard let subscribers = subscribers[message.messageKey()] else {
			return
		}
		subscribers.forEach { (subscriber) in
			(subscriber.value as? Subscriber)?.receive(message)
		}
	}
}

// from: http://stackoverflow.com/questions/24127587/how-do-i-declare-an-array-of-weak-references-in-swift
public class Weak<T: AnyObject> {
	weak var value: T?
	init (value: T) {
		self.value = value
	}
}
