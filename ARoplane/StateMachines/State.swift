//
//  ABCState.swift
//  ABCNews
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import UIKit

@objc
public class State: NSObject {
	public weak var stateMachine: StateMachine?
	
	func isValidNextState(stateClass: AnyClass) -> Bool {
		return true
	}
	
	func didEnter(from previousState: State?) {
		// to be overriden
	}
	
	func willExit(to nextState: State) {
		// to be overriden
	}

}
