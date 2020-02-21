import UIKit
import Foundation

enum Genre: String {
    case country, blues, folk
}

struct Artist {
    let name: String
    var primaryGenre: Genre?
}

struct Song {
    let title: String
    let released: Int
    var artist: Artist?
}

func getArtistGenre(song: Song) -> String {
    let artistGenre = song.artist?.primaryGenre
    return String(artistGenre?.rawValue ?? "")
}

let song1 = Song(title: "", released: 1990, artist: Artist(name: "23", primaryGenre: Genre.blues))


func checkLength(message: String) -> Bool {
    return message.count >= 10 && message.count < 10000
}

func isPalindrome(input: String) -> Bool {
    return input.lowercased() == String(input.lowercased().reversed())
}


func remove(input: String, first: Int, last: Int) -> String {
    // we require a variable to manipulate strings
    var newString = input

    if first + last >= input.count {
        return ""
    }
    
    for _ in 0..<first {
        newString.removeFirst()
    }
    
    for _ in 0..<last {
        newString.removeLast()
    }
    
    return newString
}

func removeElements(array: [Int], n: Int) -> [Int] {
    // You may need to modify newArray
    var newArray = array
    
    for _ in 0..<n {
        newArray.removeFirst()
    }
    return newArray
}

func frequency(numbers: [Int]) -> [Int: Int] {
    var frequency = [Int:Int]()
    for number in numbers {
        if let _ = frequency[number] {
            frequency[number]? += 1
        } else {
            frequency[number] = 1
        }
    }
    
    return frequency
}


func countDistinct(numbers: [Int]) -> Int {
    return Set(numbers.map {$0}).count
}

