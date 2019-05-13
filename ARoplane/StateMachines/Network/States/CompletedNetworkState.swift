//
//  CompletedNetworkState.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Alamofire
import Foundation

public class CompletedNetworkState: NetworkBaseState {
	fileprivate var action: (DataResponse<Any>?) -> Void
	fileprivate var machine: NetworkStateMachineProtocol
	
	required init(machine: NetworkStateMachineProtocol, action: @escaping (DataResponse<Any>?) -> Void) {
		self.action = action
		self.machine = machine
		super.init(name: "Completed Network State")
	}
	
	override func didEnter(from previousState: State?) {
		super.didEnter(from: previousState)
		
		self.action(self.machine.getResponse())
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		return false
	}
}
