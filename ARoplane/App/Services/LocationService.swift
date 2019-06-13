//
//  LocationService.swift
//  ARoplane
//
//  Created by Astro on 5/17/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import CoreLocation
import Foundation

public protocol LocationServiceType {
	func subscribe(name: String, subscriber: LocationServiceSubscriberType)
	func unsubscribe(name: String, subscriber: LocationServiceSubscriberType)
}

public protocol LocationServiceSubscriberType {
	func locationUpdate(_ location: CLLocation)
}

public final class LocationService: NSObject, ApplicationService, LocationServiceType {
	private let locationManager = CLLocationManager()
	private var currentLocation: CLLocation?
	private var subscribers: [String: LocationServiceSubscriberType] = [:]
	
	override init() {
		super.init()
		locationManager.delegate = self
	}
	
	private func validateAuthorization() {
		let status = CLLocationManager.authorizationStatus()
		
		guard status != .denied && status != .restricted && CLLocationManager.locationServicesEnabled() else {
			return
		}
		
		guard status != .notDetermined else {
			// don't yet have location permission - ask the user for it
			locationManager.requestWhenInUseAuthorization()
			return
		}
	}
	
	private func requestLocation() {
		validateAuthorization()
		
		locationManager.requestLocation()
	}
	
	private func start() {
		validateAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	private func stop() {
		locationManager.stopUpdatingLocation()
	}
	
	public func subscribe(name: String, subscriber: LocationServiceSubscriberType) {
		guard subscribers[name] == nil else {
			return
		}
		
		subscribers[name] = subscriber
		start()
	}
	
	public func unsubscribe(name: String, subscriber: LocationServiceSubscriberType) {
		guard subscribers[name] == nil else {
			return
		}

		subscribers.removeValue(forKey: name)
		
		if subscribers.isEmpty {
			stop()
		}
	}
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			requestLocation()
			
			if !subscribers.isEmpty {
				start()
			}
		}
	}
	
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = locations.last
		guard let location = currentLocation else {
			return
		}
		
		subscribers.forEach { (_, value) in
			value.locationUpdate(location)
		}
	}
	
	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
