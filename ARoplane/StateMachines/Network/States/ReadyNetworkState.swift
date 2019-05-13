//
//  ReadyNetworkState.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Foundation

public class ReadyNetworkState: NetworkBaseState {
	required init() {
		super.init(name: "Ready Network State")
	}

	override func isValidNextState(stateClass: AnyClass) -> Bool {
		switch stateClass {
		case is FetchNetworkState.Type:
			return true
			
		default:
			return false
		}
	}
}
