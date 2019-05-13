//
//  NetworkStateMachine.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Alamofire
import Foundation

public struct NetworkStateConfiguration {
	var url: String
	var completed: ((DataResponse<Any>?) -> Void)
	var failed: ((Error?) -> Void)
	var canceled: (() -> Void)
}

public protocol NetworkStateMachineProtocol {
	func cancel()
	func getResponse() -> DataResponse<Any>?
	func setResponse(_ response: DataResponse<Any>?)
	func getError() -> Error?
	func setError(_ error: Error?)
	func getNetworkStateConfiguration() -> NetworkStateConfiguration
	func getStateMachine() -> StateMachine
}

public class NetworkStateMachine: NSObject, NetworkStateMachineProtocol {
	var stateMachine: StateMachine!
	var error: Error?
	var response: DataResponse<Any>?
	var request: DataRequest?
	
	fileprivate var networkStateConfiguration: NetworkStateConfiguration

	class var defaultConfig: URLSessionConfiguration {
		let defaultConfig = URLSessionConfiguration.default
		defaultConfig.timeoutIntervalForRequest = 30
		
		// Change this when going to production or add a new config
		defaultConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
		return defaultConfig
	}
	
	init(_ networkStateConfiguration: NetworkStateConfiguration) {
		self.networkStateConfiguration = networkStateConfiguration
		super.init()
		
		stateMachine = StateMachine(states: [
			ReadyNetworkState(),
			FetchNetworkState(machine: self),
			CompletedNetworkState(machine: self, action: networkStateConfiguration.completed),
			FailedNetworkState(machine: self, action: networkStateConfiguration.failed),
			CanceledNetworkState(networkStateConfiguration.canceled)
			])
	
		_ = stateMachine.enter(ReadyNetworkState.self)
	}
	
	public func cancel() {
		if self.request != nil && self.stateMachine.canEnterState(CanceledNetworkState.self) {
			self.request?.cancel()
			self.stateMachine.enter(CanceledNetworkState.self)
		}
	}
	
	public func getResponse() -> DataResponse<Any>? {
		return self.response
	}
	
	public func getError() -> Error? {
		return self.error
	}

	public func setResponse(_ response: DataResponse<Any>?) {
		self.response = response
	}
	
	public func setError(_ error: Error?) {
		self.error = error
	}
	
	public func getNetworkStateConfiguration() -> NetworkStateConfiguration {
		return self.networkStateConfiguration
	}
	
	public func getStateMachine() -> StateMachine {
		return self.stateMachine
	}
}
