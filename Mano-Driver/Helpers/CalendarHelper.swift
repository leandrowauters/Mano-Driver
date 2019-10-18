//
//  CalendarHelper.swift
//  Mano-Driver
//
//  Created by Leandro Wauters on 10/17/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import EventKit

protocol CalendarDelegate: AnyObject {
    func didAddToCalendar(calendar: String)
    func errorAddingToCalendar(error: AppError)
}

class CalendarHelper {

    weak var calendarDelegate: CalendarDelegate?
    
    public func addToCalendar(ride: Ride) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            addEvent(eventStore: eventStore, ride: ride)
            
        case .denied:
            calendarDelegate?.errorAddingToCalendar(error: .calendarError("Access Denied"))
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if let error = error {
                        self?.calendarDelegate?.errorAddingToCalendar(error: .calendarError(error.localizedDescription))
                    }
                    if granted {
                        self?.addEvent(eventStore: eventStore, ride: ride)
                    }
            })
        default:
            calendarDelegate?.errorAddingToCalendar(error: .calendarError("Error Unknown"))
        }
    }
    
    func addEvent(eventStore: EKEventStore, ride: Ride) {
        createEvent(store: eventStore, ride: ride) { [weak self] error, calendar in
            if let error = error {
                self?.calendarDelegate?.errorAddingToCalendar(error: error)
            }
            if let calendar = calendar {
                self?.calendarDelegate?.didAddToCalendar(calendar: calendar)
            }
        }
    }
    func createEvent(store: EKEventStore, ride: Ride, completion: (AppError?, String?) -> Void) {
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

