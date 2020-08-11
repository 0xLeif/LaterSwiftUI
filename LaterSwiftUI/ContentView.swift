//
//  ContentView.swift
//  LaterSwiftUI
//
//  Created by Zach Eriksen on 8/6/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import SwiftUI
import Later

class FetcherObject: ObservableObject {
    @Published var value: String = "Fetching..."
    
    lazy var fetchTask = Later.scheduleRepeatedTask(delay: .seconds(5)) { (task) in
        Later
            .main {
                self.value = "Fetching Again..."
                
        }
            .and
            .fetch(url: URL(string: "https://jsonplaceholder.typicode.com/todos/\(Int.random(in: 1 ... 100))")!)
            .map { (data, _, _) in
                data!
        }
        .whenSuccess { (data) in
            
            Later
                .main {
                    self.value = String(data: data,
                                        encoding: .utf8) ?? "-1"
            }
        }
    }
    
    init() {
        print("Starting Task: \(fetchTask)")
        
        Later.scheduleTask(in: .seconds(50)) {
            print("10 Seconds before cancelled!")
            var count = 10
            Later.scheduleRepeatedTask(delay: .seconds(1)) { (task) in
                if count == 0 {
                    task.cancel()
                }
                print(count)
                count -= 1
            }
        }
        
        
        let cancelTask = Later
            .scheduleTask(in: .minutes(1)) { [weak self] in
                self?.fetchTask.cancel()
        }
    }
}

struct ContentView: View {
    @ObservedObject var object = FetcherObject()
    
    var body: some View {
        Text(object.value)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
