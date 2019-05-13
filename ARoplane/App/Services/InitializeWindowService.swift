//
//  CoreAppService.swift
//  ARoplane
//
//  Created by Astro on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import UIKit

public protocol InitializeWindowServiceType {
	var appStart: Date { get }
}

public final class InitializeWindowService: NSObject, ApplicationService, InitializeWindowServiceType {
	
	public let appStart = Date()
	
	// MARK: - App Delegate
	
	public func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let viewController = MainViewController(nibName: "MainViewController", bundle: nil)

		guard var applicationDelegate = UIApplication.shared.delegate as? AppDelegateType else {
			return false
		}

		let frame = UIScreen.main.bounds
		applicationDelegate.window = UIWindow(frame: frame)

		applicationDelegate.window?.rootViewController = viewController
		applicationDelegate.window?.makeKeyAndVisible()
		
		return true
	}
}
