//
//  AppDelegate.swift
//  ARoplane
//
//  Created by Astro on 5/10/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Compass
import Swinject
import UIKit

public protocol AppDelegateType {
	var window: UIWindow? { get set }
	var container: Container { get set }
}

@UIApplicationMain
private class AppDelegate: PluggableApplicationDelegate, AppDelegateType {

	lazy var container = Container { inboundContainer in
		weak var weakContainer = inboundContainer
		inboundContainer.register(InitializeWindowServiceType.self) { _ in
			InitializeWindowService()
		}.inObjectScope(.container)

		inboundContainer.register(LocationServiceType.self) { _ in
			LocationService()
		}.inObjectScope(.container)
	}

	override var services: [ApplicationService] {
		var services: [ApplicationService] = []
		
		if _isDebugAssertConfiguration() {
			services.append(contentsOf: [
				])
		}
		
		guard let initializeWindowService =
			(container.resolve(InitializeWindowServiceType.self) as? ApplicationService) else {
			return services
		}
		
		// in theory, it shouldn't matter when services are spun up,
		// but some service need to be first and last.
		services.append(contentsOf: [
			initializeWindowService
			])
		
		return services
	}
	
	@objc func getService(fromName: String) -> AnyObject? {
		for service in services {
			if "\(type(of: service))" == fromName {
				return service
			}
		}
		
		return nil
	}
}
