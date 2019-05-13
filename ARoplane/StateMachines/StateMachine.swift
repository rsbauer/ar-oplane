//
//  StateMachine.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB All rights reserved.
//

// StateMachine & State objects are for iOS 8 support.
// Once iOS 8 support has been deprecated, please switch over to
// use Apple's GameplayKit StateMachine and State objects
// Use: import GameplayKit
// and: GKStateMachine and GKState

import UIKit

@objc
public class StateMachine: NSObject {

	public var currentState: AnyObject?
	
	fileprivate var states: [AnyObject]
	
	init(states: [AnyObject]) {
		self.states = states
	}
	
	func canEnterState(_ stateClass: AnyClass) -> Bool {
		if currentState == nil {
			return false
		}
		
		if currentState is State {
			return (currentState as? State)?.isValidNextState(stateClass: stateClass) ?? false
		}
		
		return false
	}
	
	@discardableResult
	func enter(_ stateClass: AnyClass) -> Bool {
		var previousState: AnyObject?
		
		for state in states {
			if type(of: state) == stateClass, let stateExists = state as? State {
				if let currentStateExists = self.currentState as? State {
					currentStateExists.willExit(to: stateExists)
					previousState = currentStateExists
				}
				
				if let lastState = previousState as? State {
					if lastState.isValidNextState(stateClass: type(of: state)) == false {
						return false
					}
				}

				self.currentState = state
				(self.currentState as? State)?.stateMachine = self
				(self.currentState as? State)?.didEnter(from: (previousState as? State))
			}
			
		}
		
		return true
	}
	
	func isInState(_ stateClass: AnyClass) -> Bool {
		if let state = currentState {
			return type(of: state) == stateClass
		}
		
		return false
	}
}
