//
//  ContentView.swift
//  step-counter
//
//  Created by Key Hui on 10/18/19.
//  Copyright © 2019 keyfun. All rights reserved.
//

import SwiftUI
import UIKit
import CoreMotion
import Dispatch

struct ContentView: View {

    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    @State var shouldStartUpdating = false
    @State var startDate: Date? = nil

    var body: some View {
        NavigationView {
            Text("Step Counter")
        }.onAppear {
            print("onAppear")
//            guard let startDate = self.startDate else { return }
//            self.updateStepsCountLabelUsing(startDate: startDate)
            self.onStart()
        }
    }

    func onStart() {
//        startButton.setTitle("Stop", for: .normal)
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }

    func onStop() {
//        startButton.setTitle("Start", for: .normal)
        startDate = nil
        stopUpdating()
    }

    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
//            activityTypeLabel.text = "Not available"
        }

        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
//            stepsCountLabel.text = "Not available"
        }
    }

    func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            print("Not available")
            onStop()
//            activityTypeLabel.text = "Not available"
//            stepsCountLabel.text = "Not available"
        default: break
        }
    }

    func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }

    func on(error: Error) {
        //handle error
    }

    func updateStepsCountLabelUsing(startDate: Date) {
        pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
            if let error = error {
                self.on(error: error)
            } else if let pedometerData = data {
                print(pedometerData)
//                DispatchQueue.main.async {
//                    self.stepsCountLabel.text = String(describing: pedometerData.numberOfSteps)
//                }
            }
        }
    }

    func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
            guard let activity = activity else { return }
            print(activity)
            //            DispatchQueue.main.async {
            //                if activity.walking {
            //                    self?.activityTypeLabel.text = "Walking"
            //                } else if activity.stationary {
            //                    self?.activityTypeLabel.text = "Stationary"
            //                } else if activity.running {
            //                    self?.activityTypeLabel.text = "Running"
            //                } else if activity.automotive {
            //                    self?.activityTypeLabel.text = "Automotive"
            //                }
            //            }
        }
    }

    func startCountingSteps() {
        pedometer.startUpdates(from: Date()) { pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            print(pedometerData)
//            DispatchQueue.main.async {
//                self?.stepsCountLabel.text = pedometerData.numberOfSteps.stringValue
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
