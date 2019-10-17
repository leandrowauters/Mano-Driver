//
//  EventKitHelper.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/17/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import EventKit

protocol CalendarDelegate: AnyObject {
    func didAddToCalendar()
}

class EventKitHelper {

    public func addToCalendar(ride: Ride, completion: @escaping(AppError?, String?) -> Void) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore, ride: ride) { (error, calendar) in
                completion(error,calendar)
            }
            
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if let error = error {
                      completion(.calendarError(error.localizedDescription), nil)
                    }
                    if granted {
                        self!.insertEvent(store: eventStore, ride: ride, completion: { (error, calendar) in
                            completion(nil, calendar)
                        })
                        
                    }
            })
        default:
            print("Case default")
        }
    }
    
    func insertEvent(store: EKEventStore, ride: Ride, completion: (AppError?, String?) -> Void) {
        // 1
        guard let calendar = store.defaultCalendarForNewEvents else {
            completion(.calendarError("No calendar found"), nil)
            return
        }
        let event = EKEvent(eventStore: store)
        
            // 2
                // 3
        let startDate = ride.appointmentDate.stringToDate()
        let endDate = Date(timeInterval: 7200, since: startDate)
        event.title = ride.passanger
        event.location = ride.pickupAddress
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: store.calendars(for: .event))
        for eventCreated in store.events(matching: predicate) {
            guard eventCreated.title != event.title else {
                completion(.calendarError("Event already in calendar"), nil)
                return}
        }
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = calendar


        do {
            try store.save(event, span: .thisEvent)
            completion(nil, calendar.title)
        }
        catch {
            completion(.calendarError("Error saving event in calendar"), nil)
            print("Error saving event in calendar")
            
        }
    }
}

