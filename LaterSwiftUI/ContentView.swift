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
            .fetch(url: URL(string: "https://scontent-dfw5-2.cdninstagram.com/v/t51.2885-15/sh0.08/e35/s640x640/117229741_311067766680366_4524756043560145576_n.jpg?_nc_ht=scontent-dfw5-2.cdninstagram.com&_nc_cat=106&_nc_ohc=cz0h_b8haQcAX9-Mb9g&oh=c729112c167da8bf01fc1e8164c8089a&oe=5F5B76BF")!)
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
