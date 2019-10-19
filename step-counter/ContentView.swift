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

struct ContentView: View {

    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    @State var isStarted = false
    @State var startDate: Date? = nil
    @State var activityType: String = ""
    @State var stepsCount: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    if self.isStarted {
                        self.onStop()
                    } else {
                        self.onStart()
                    }
                }) {
                    Text("\(isStarted ? "Stop" : "Start")").frame(minWidth: 0, maxWidth: .infinity)
                }.padding(.all)
                Text("\(startDate?.description ?? " - ")").padding()
                Text("activityType = \(activityType)").padding()
                Text("stepCount = \(stepsCount)").padding()
                Spacer()
            }.navigationBarTitle("Step Counter")
        }.onAppear {
            print("onAppear")
            guard let startDate = self.startDate else { return }
            self.updateStepsCountLabelUsing(startDate: startDate)
        }
    }

    func onStart() {
        isStarted = true
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }

    func onStop() {
        isStarted = false
        startDate = nil
        stopUpdating()
    }

    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            activityType = "Not available"
        }

        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            stepsCount = "Not available"
        }
    }

    func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            print("Not available")
            onStop()
            activityType = "Not available"
            stepsCount = "Not available"
        default: break
        }
    }

    func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }

    func on(error: Error) {
        print(error)
    }

    func updateStepsCountLabelUsing(startDate: Date) {
        pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
            if let error = error {
                self.on(error: error)
            } else if let pedometerData = data {
                print(pedometerData)
                self.stepsCount = String(describing: pedometerData.numberOfSteps)
            }
        }
    }

    func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
            guard let activity = activity else { return }
            if activity.walking {
                self.activityType = "Walking"
            } else if activity.stationary {
                self.activityType = "Stationary"
            } else if activity.running {
                self.activityType = "Running"
            } else if activity.automotive {
                self.activityType = "Automotive"
            }
        }
    }

    func startCountingSteps() {
        pedometer.startUpdates(from: Date()) { pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            print("startCountingSteps")
            print(pedometerData)
            self.stepsCount = pedometerData.numberOfSteps.stringValue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
