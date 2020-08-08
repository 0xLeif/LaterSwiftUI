# LaterSwiftUI
SwiftUI Later Test

Example

```swift
import SwiftUI
import Later

class FetcherObject: ObservableObject {
    @Published var value: String = "Fetching..."
    
    init() {
        print("init")
        fetch()
    }
    
    func fetch() {
        Later
            .main { self.value = "Fetching Again..." }
            .then
            .do(withDelay: 3) {
                Later.fetch(url: URL(string: "https://jsonplaceholder.typicode.com/todos/\(Int.random(in: 1 ... 100))")!)
                    .whenSuccess { (data, _, _) in
                        guard let data = data else {
                            return
                        }
                        
                        Later
                            .main { self.value = String(data: data, encoding: .utf8) ?? "-1" }
                            .then
                            .do(withDelay: 5, work: self.fetch)
                }
        }
    }
}
```
