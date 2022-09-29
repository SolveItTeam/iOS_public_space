//
//  EventTimer.swift
//
//  Created by SOLVEIT on 16.11.21.
//  Copyright © 2021 SolveIT. All rights reserved.
//

import Foundation
import Combine

/// Timer that handle active/inactive app state
public final class EventTimer {
    public enum Event {
        case ended
        case countdown(value: Int)
    }
    
    private enum State {
        case active
        case inactive
    }
    
    //MARK: - Properties
    private let duration: TimeInterval
    private let cancelBag: CancelBag
    private let sceneLifecyclePublisher: SceneLifecyclePublisher
    private let eventSubject: PassthroughSubject<Event, Never>
    private var timer: Timer.TimerPublisher
    
    private var state: State
    private var endDate: Date?
    private var timerCancellable: Cancellable?
    
    //MARK: - Initialization
    public init(
        duration: TimeInterval,
        sceneLifecyclePublisher: SceneLifecyclePublisher
    ) {
        self.duration = duration
        self.sceneLifecyclePublisher = sceneLifecyclePublisher
        self.cancelBag = .init()
        self.state = .inactive
        self.eventSubject = .init()
        
        self.timer = Timer.TimerPublisher(
            interval: 1,
            tolerance: nil,
            runLoop: .main,
            mode: .common,
            options: nil
        )
    }
    
    //MARK: - Lifecycle
    public func start(eventPublisher: @escaping (AnyPublisher<Event, Never>) -> Void) {
        guard state != .active else { return }
        subscribeToSystemStateEvents()
        
        let start = Date()
        endDate = start.addingTimeInterval(duration)
        state = .active
        eventPublisher(eventSubject.eraseToAnyPublisher())
        eventSubject.send(.countdown(value: Int(duration)))
        
        createTimer(startDate: start)
    }
    
    public func stop() {
        state = .inactive
        eventSubject.send(.ended)
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

//MARK: - Private
private extension EventTimer {
    func createTimer(startDate: Date) {
        timerCancellable = timer.autoconnect()
                                .map({ [weak self] date -> Int in
                                    guard let self = self,
                                          let end = self.endDate else {
                                              return 0
                                          }
                                    return self.secondsBetweenDates(from: date, end: end)
                                })
                                .map({ seconds in
                                    seconds == 0 || seconds < 0 ? Event.ended : Event.countdown(value: seconds)
                                })
                                .sink(receiveValue: { [weak self] event in
                                    self?.eventSubject.send(event)
                                    switch event {
                                    case .ended:
                                        self?.stop()
                                    case .countdown:
                                        break
                                    }
                                })
    }
    
    func secondsBetweenDates(from: Date, end: Date) -> Int {
        Calendar.current.dateComponents([.second], from: from, to: end).second ?? 0
    }
    
    func subscribeToSystemStateEvents() {
        sceneLifecyclePublisher.sink { [weak self] systemStateEvent in
            guard let self = self else { return }
            switch systemStateEvent {
            case .didEnterBackground:
                self.timerCancellable?.cancel()
                self.timerCancellable = nil
            case .willEnterForeground:
                guard let end = self.endDate else { return }
                let secondsBetweenDates = self.secondsBetweenDates(from: .init(), end: end)
                if secondsBetweenDates < 0 || secondsBetweenDates == 0 {
                    self.stop()
                } else {
                    self.createTimer(startDate: Date())
                }
            }
        }.store(in: cancelBag)
    }
}
