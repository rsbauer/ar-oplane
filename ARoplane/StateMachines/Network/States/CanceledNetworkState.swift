//
//  CanceledNetworkState.swift
//
//  Created by Bauer, Robert S. on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import Foundation

public class CanceledNetworkState: NetworkBaseState {
	fileprivate var action: () -> Void
	
	required init(_ action: @escaping () -> Void) {
		self.action = action
		super.init(name: "Canceled Network State")
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		return false
	}
}
