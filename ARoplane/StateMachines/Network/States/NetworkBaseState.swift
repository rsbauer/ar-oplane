//
//  NetworkBaseState.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Foundation

public class NetworkBaseState: State {
	// MARK: Properties
	
	let name: String
	
	// MARK: Initialization
	
	init(name: String) {
		self.name = name
	}
	
	// MARK: State overrides
	override func didEnter(from previousState: State?) {
		super.didEnter(from: previousState)
	}
	
	// MARK: Methods
}
