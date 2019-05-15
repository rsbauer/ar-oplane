//
//  MainViewController.swift
//  ARoplane
//
//  Created by Astro on 5/12/19.
//  Copyright © 2019 RSB. All rights reserved.
//

import ARCL
import CoreLocation
import UIKit

// See: https://github.com/ProjectDent/ARKit-CoreLocation

public class MainViewController: UIViewController {
	
	private var sceneLocationView = SceneLocationView()

	public override func viewDidLoad() {
		super.viewDidLoad()
		
		let coordinate = CLLocationCoordinate2D(latitude: 40.7769, longitude: -73.8740)
		let location = CLLocation(coordinate: coordinate, altitude: 300)
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		label.text = "LGA"
		label.backgroundColor = .green
		label.textAlignment = .center
		
		let annotationNode = LocationAnnotationNode(location: location, view: label)
		sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

		let coordinate2 = CLLocationCoordinate2D(latitude: 40.6413, longitude: -73.7781)
		let location2 = CLLocation(coordinate: coordinate2, altitude: 300)
		let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		label2.text = "JFK"
		label2.backgroundColor = .blue
		label2.textAlignment = .center
		let annotationNode2 = LocationAnnotationNode(location: location2, view: label2)
		sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode2)
		
		view.addSubview(sceneLocationView)
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		sceneLocationView.run()
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		sceneLocationView.frame = view.bounds
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		sceneLocationView.pause()
		sceneLocationView.removeFromSuperview()
		super.viewWillDisappear(animated)
	}
}
