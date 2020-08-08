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
    
    init() {
        fetch()
    }
    
    func fetch() {
        Later
            .main { self.value = "Fetching Again..." }
            .and
            .do(withDelay: 3) {
                Later.fetch(url: URL(string: "https://jsonplaceholder.typicode.com/todos/\(Int.random(in: 1 ... 100))")!)
                    .whenSuccess { (data, _, _) in
                        guard let data = data else {
                            return
                        }
                        
                        Later
                            .main { self.value = String(data: data, encoding: .utf8) ?? "-1" }
                            .and
                            .do(withDelay: 5, work: self.fetch)
                }
        }
    }
}

struct ContentView: View {
    @ObservedObject var object = FetcherObject()
    
    var body: some View {
        Text(object.value)
            .onAppear {
                Later
                    .do {
                        print("Do First")
                        sleep(10)
                        print("Finish first")
                }
                    .when { event in
                        event
                            .whenComplete { _ in
                                print("Do After")
                        }
                }
                .do {
                    print("Do Something Else")
                    sleep(3)
                    print("Fin 3")
                }
                .and
                .do {
                    print("Do Something Else")
                    sleep(1)
                    print("fin 1")
                }
                .and
                .do {
                    print("Finally do")
                    sleep(4)
                    print("fin 4")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
