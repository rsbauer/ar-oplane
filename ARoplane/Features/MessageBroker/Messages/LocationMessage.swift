//
//  LocationMessage.swift
//  ARoplane
//
//  Created by Astro on 5/17/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import CoreLocation
import Foundation

public enum LocationMessage: Message {
	
	case update(CLLocation)
	
	static let updateType = "update"
	
	public func messageKey() -> MessageKey {
		switch self {
		// swiftlint:disable empty_enum_arguments
		case .update(_):
			return LocationMessage.updateType
		}
		// swiftlint:enable empty_enum_arguments
	}
}
