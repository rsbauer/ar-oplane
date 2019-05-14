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
	
		sceneLocationView.run()
		view.addSubview(sceneLocationView)
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		sceneLocationView.frame = view.bounds
	}
}
