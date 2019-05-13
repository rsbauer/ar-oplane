//
//  FetchNetworkState.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Alamofire
import Foundation

public class FetchNetworkState: NetworkBaseState {
	fileprivate var machine: NetworkStateMachineProtocol
	var error: Error?
	var response: DataResponse<Any>?
	var request: DataRequest?

	fileprivate var sessionManager: SessionManager =
		Alamofire.SessionManager(configuration: NetworkStateMachine.defaultConfig)

	required init(machine: NetworkStateMachineProtocol) {
		self.machine = machine
		super.init(name: "Fetch Network State")
	}

	override func didEnter(from previousState: State?) {
		super.didEnter(from: previousState)
		
		fetch(self.machine.getNetworkStateConfiguration().url)
	}
	
	override func willExit(to nextState: State) {
		if type(of: nextState) is CanceledNetworkState.Type {
			self.machine.cancel()
		}
	}

	override func isValidNextState(stateClass: AnyClass) -> Bool {
		switch stateClass {
		case is CompletedNetworkState.Type,
			 is FailedNetworkState.Type,
			 is CanceledNetworkState.Type:
			return true
			
		default:
			return false
		}
	}
	
	internal func fetch(_ url: String) {
		self.request = self.sessionManager.request(url).responseJSON { [weak self ] response in
			guard let strongSelf = self else {
				return
			}
			
			print(response.timeline.debugDescription)
			
			switch response.result {
			case .success:
				strongSelf.response = response
				strongSelf.machine.setResponse(response)
				strongSelf.machine.getStateMachine().enter(CompletedNetworkState.self)
				
			case .failure(let error):
				strongSelf.error = error
				strongSelf.machine.setError(error)
				strongSelf.machine.getStateMachine().enter(FailedNetworkState.self)
			}
		}
	}
	
}
