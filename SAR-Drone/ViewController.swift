//
//  ViewController.swift
//  SAR-Drone
//
//  Created by Travis Tomer on 2/11/20.
//  Copyright © 2020 Travis Tomer. All rights reserved.
//

import UIKit
import DJIUXSDK

class ViewController: DUXDefaultLayoutViewController {

    // Create mission start and stop buttons
    @IBOutlet var missionStart: UIButton!
    @IBOutlet var missionStop: UIButton!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent;
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.missionStop?.isHidden = true

        self.contentViewController?.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant:0).isActive = true
        self.contentViewController?.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.contentViewController?.view.setNeedsDisplay()

        // Add key listener for mission events
        self.addKeyListener()
    }
    
    // missionStart button
    @IBAction func missionStartAction(_ sender: UIButton) {
        if let isRunning = DJISDKManager.missionControl()?.isTimelineRunning, isRunning == false {
            //Hdrpano.startAdvancedVirtualStick()
            //self.shootTLPano()
            self.missionStop.isHidden = false
        } else {
            if let isPaused = DJISDKManager.missionControl()?.isTimelinePaused, isPaused == false {
                DJISDKManager.missionControl()?.pauseTimeline()
                self.missionStart.setTitle("Resume", for: .normal)
            } else {
                DJISDKManager.missionControl()?.resumeTimeline()
            }
        }
    }
    
    @IBAction func missionStopAction(){
        NSLog("MISSION STOPPED")
    }
    
    
    // addKeyListener func start
    func addKeyListener() {
        DJISDKManager.missionControl()?.addListener(self, toTimelineProgressWith: {(event: DJIMissionControlTimelineEvent,
            element: DJIMissionControlTimelineElement?, error: Error?, info: Any?) in
            
            if error != nil {
                print("Timeline Error in mission Control \((String(describing: error!)))")
            }
            
            let schedule = DJISDKManager.missionControl()?.currentTimelineMarker    // The task number during timelne
            let elements = DJISDKManager.missionControl()?.runningElement           // Running timeline element
            
            switch event {
            case .started:
                print("Timeline Element \(String(describing: elements)) Marker \(schedule!)")
            case .startError:
                print("Start error")
            case .paused:
                print("Paused \(String(describing: elements))")
            case .pauseError:
                print("Pause error \(String(describing: elements))")
            case .resumed:
                print("Resumed \(String(describing: elements))")
            case .resumeError:
                print("Resume error \(String(describing: elements))")
            case .stopped:
                print("Mission stopped successfully \(String(describing: elements))")
            case .stopError:
                print("Stop error \(String(describing: elements))")
            case .finished:
                print("Finished \(String(describing: elements))")
                if schedule != nil {
                    self.missionStart.setTitle("Running " + String(Int(schedule!)/2), for: .normal)
                }
                if elements == nil {
                    print("Mission finished")
                    //Hdrpano.stopAdvancedVirtualStick()
                    self.missionStop.isHidden = true
                    self.missionStart.setTitle("Start Mission", for: .normal)
                }
            default:
                break
            }
        })
    }// addKeyListener func stop
    
    
}
