//
//  MainViewController.swift
//  ARoplane
//
//  Created by Astro on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import ARCL
import CoreLocation
import Swinject
import UIKit

// See: https://github.com/ProjectDent/ARKit-CoreLocation
// Free feed
// https://opensky-network.org/api/states/all?lamin=40.5&lomin=-74.0&lamax=40.8&lomax=-73.0
// piaware build: https://flightaware.com/adsb/piaware/build
// adsbexchange feeder image: https://adsbexchange.com/how-to-feed/

public struct BoundingBox {
	let minLat: Double
	let minLon: Double
	let maxLat: Double
	let maxLon: Double
}

public class MainViewController: UIViewController {
	
	enum Constants {
		static let aircraftRefreshIntervalSeconds: TimeInterval = 30
		static let locationSubscriberName = "MainViewController"
		static let metersInMile = 1609.34
		static let mileRadius: Double = 20
	}
	
	private var sceneLocationView = SceneLocationView()
	private let adjustNorthByTappingSidesOfScreen = true
	private var networkMachine: NetworkStateMachine?
	private var aircraftRefreshTimer: Timer?
	private var container: Container?
	private var locationService: LocationServiceType?
	private var currentLocation: CLLocation?
	
	public override func viewDidLoad() {
		super.viewDidLoad()

		if let applicationDelegate = UIApplication.shared.delegate as? AppDelegateType {
			container = applicationDelegate.container
			locationService = container?.resolve(LocationServiceType.self)
		}
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		locationService?.subscribe(name: Constants.locationSubscriberName, subscriber: self)

		view.addSubview(sceneLocationView)
		sceneLocationView.run()
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		locationService?.unsubscribe(name: Constants.locationSubscriberName, subscriber: self)
		sceneLocationView.pause()
		sceneLocationView.removeFromSuperview()
		super.viewWillDisappear(animated)
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		sceneLocationView.frame = view.bounds
	}

	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first, let view = touch.view else {
			return
		}
		
		let location = touch.location(in: self.view)
		
		if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
			print("left side of the screen")
			sceneLocationView.moveSceneHeadingAntiClockwise()
		}
		
		if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
			print("right side of the screen")
			sceneLocationView.moveSceneHeadingClockwise()
		}
	}
	
	func startAirplaneScan(location: CLLocation) {
		grabSomeAirplanes(location: location)
		
		aircraftRefreshTimer = Timer.scheduledTimer(
			withTimeInterval: Constants.aircraftRefreshIntervalSeconds,
			repeats: true,
			block: { [weak self] (_) in
				guard let strongSelf = self, let location = strongSelf.currentLocation else {
					return
				}
				
				strongSelf.grabSomeAirplanes(location: location)
			})
	}
	
	func grabSomeAirplanes(location: CLLocation) {
		let box = getBoundingBox(for: location)
		let url = "https://opensky-network.org/api/states/all?lamin=\(box.minLat)&lomin=\(box.minLon)&" +
			"lamax=\(box.maxLat)&lomax=\(box.maxLon)"
		let configuration = NetworkStateConfiguration(url: url, completed: { [weak self] (response) in
			guard let strongSelf = self else {
				return
			}

			// success
			var aircraft: [StateVector] = []
			if let items = (response?.value as? [String: Any])?["states"] as? [[Any]] {
				for item in items {
					let result = StateVector(
						icao24: item[0] as? String,
						callsign: item[1] as? String,
						originCountry: item[2] as? String,
						timePosition: item[3] as? Int,
						lastContact: item[4] as? Int,
						longitude: item[5] as? Double,
						latitude: item[6] as? Double,
						baroAltitude: item[7] as? Double,
						onGround: item[8] as? Bool ?? false,
						velocity: item[9] as? Double,
						trueTrack: item[10] as? Double,
						verticalRate: item[11] as? Double,
						sensors: item[12] as? [Int],
						geoAltitude: item[13] as? Double,
						squawk: item[14] as? String,
						spi: item[15] as? Bool ?? false,
						positionSource: item[16] as? Int
					)
					
					aircraft.append(result)
				}
				strongSelf.updateScene(with: aircraft)
			}
		}, failed: { (error) in
			// failed
			print("Request failed! \(error.debugDescription)")
		}, canceled: {
			// cancelled
		})
		
		networkMachine = NetworkStateMachine(configuration)
		networkMachine?.stateMachine.enter(FetchNetworkState.self)
	}
	
	func getBoundingBox(for location: CLLocation) -> BoundingBox {
		let meters = Constants.mileRadius * Constants.metersInMile
		let (min, max) = location.coordinate.calculateBoundingCoordinates(withDistance: meters)
		return BoundingBox(minLat: min.latitude, minLon: min.longitude, maxLat: max.latitude, maxLon: max.longitude)
	}
	
	func updateScene(with aircraft: [StateVector]) {
		sceneLocationView.removeAllNodes()
		addNorth()
		
		for airplane in aircraft {
			guard let latitude = airplane.latitude,
				let longitude = airplane.longitude,
				let altitude = airplane.geoAltitude,
				let callsign = airplane.callsign  else {
				break
			}
			
			let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			let location = CLLocation(coordinate: coordinate, altitude: altitude)
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 75))
			label.text = callsign
			label.backgroundColor = .green
			label.textAlignment = .center
			let annotationNode = LocationAnnotationNode(location: location, view: label)
			sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
		}
	}

	private func addNorth() {
		// north
		let coordinate3 = CLLocationCoordinate2D(latitude: 90, longitude: 0)
		let location3 = CLLocation(coordinate: coordinate3, altitude: 300)
		let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 75))
		label3.text = "NORTH"
		label3.backgroundColor = .lightGray
		label3.textAlignment = .center
		let annotationNode3 = LocationAnnotationNode(location: location3, view: label3)
		sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode3)
		
		sceneLocationView.orientToTrueNorth = false
	}
}

extension MainViewController: LocationServiceSubscriberType {
	public func locationUpdate(_ location: CLLocation) {
		currentLocation = location
		startAirplaneScan(location: location)
	}
}
