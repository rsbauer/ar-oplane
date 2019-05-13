//
//  FailedNetworkState.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Foundation

public class FailedNetworkState: NetworkBaseState {
	fileprivate var action: (Error?) -> Void
	fileprivate var machine: NetworkStateMachineProtocol

	required init(machine: NetworkStateMachineProtocol, action: @escaping (Error?) -> Void) {
		self.action = action
		self.machine = machine
		super.init(name: "Failed Network State")
	}
	
	override func didEnter(from previousState: State?) {
		super.didEnter(from: previousState)
		
		self.action(self.machine.getError())
	}

	override func isValidNextState(stateClass: AnyClass) -> Bool {
		return false
	}
}
