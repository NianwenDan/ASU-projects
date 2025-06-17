/*
 Please open the console to check print out message!
 */
import UIKit

// Question 1
var age: Int? = 40
let gravity = 9.8


// Question 2
print("Question 2")
var fatMass = 42.5
var rfm: String?

switch fatMass {
case 0...20:
    rfm = "You are Underfat"
case 20...35:
    rfm = "You are Healthy"
case 35...42:
    rfm = "You are Overfat"
default:
    rfm = "You are Obese"
}
print("rfm: \(rfm ?? "N/A")")
print()


// Question 3
print("Question 3")
var aStr = "This is a test String!!!"
var aStarRevered = ""
var aStarReveredByWords = String()
for i in stride(from: aStr.count - 1, to: -1, by: -1) {
    let index = aStr.index(aStr.startIndex, offsetBy: i)
    aStarRevered += String(aStr[index])
}
print(aStarRevered)

let inputList = aStr.split(separator: " ")
for word in inputList {
    var revered = ""
    for i in stride(from: word.count - 1, to: -1, by: -1) {
        let index = word.index(word.startIndex, offsetBy: i)
        revered += String(word[index])
    }
    aStarReveredByWords += revered + " "
}
aStarReveredByWords = String(aStarReveredByWords.dropLast())
print(aStarReveredByWords)
print()


// Question 4
print("Question 4")
func sumUp(_ arr: Array<Int>) -> (Int, Int) {
    var sumEven = 0
    var sumOdd = 0
    for v in arr {
        // Check if element is > 0
        if v < 0 {
            continue
        }
        if v % 2 == 0 {
            sumEven += v
        } else {
            sumOdd += v
        }
    }
    return (sumEven, sumOdd)
}
let (sumEven, sumOdd) = sumUp([2, 4, 6, 8, 1, -1, -2])
print("sum of even values: \(sumEven); sum of odd values: \(sumOdd)")

func getMaxMinString(_ arr: Array<String>) -> (Int, Int) {
    var maxLength = 0
    var minLength = Int.max
    for str in arr {
        let strLen = str.count
        if strLen > maxLength {
            maxLength = strLen
        }
        if strLen < minLength {
            minLength = strLen
        }
    }
    return (maxLength, minLength)
}
let (longestStrLen, shortestStrLen) = getMaxMinString(["String", "1", "22", "The longest String"])
print("The longest string length is \(longestStrLen); The shorest string length is \(shortestStrLen)")

func seqSearch(arr: Array<Int>, target: Int) -> Bool {
    for value in arr {
        if value == target {
            return true
        }
    }
    return false
}
print(seqSearch(arr: [1, 2, 5, 2, 4], target: 10))
print()


// Question 5
print("Question 5")
class CityStatistics {
    private(set) var cityName: String?
    private(set) var population: Int?
    private var longtitude: Double?
    private var latitude: Double?
    
    init(cityName: String? = nil, population: Int? = nil, longtitude: Double? = nil, latitude: Double? = nil) {
        self.cityName = cityName
        self.population = population
        self.longtitude = longtitude
        self.latitude = latitude
    }
    
    func getPopulation() -> Int {
        return self.population ?? -1
    }
    
    func getLatitude() -> Double {
        return self.latitude ?? -1
    }
}
print()


// Question 6
print("Question 6")
let cities = ["Paris": CityStatistics(cityName: "Paris", population: 2161000, longtitude: 2.3522, latitude: 48.8566),
              "Los Angeles": CityStatistics(cityName: "Los Angeles", population: 3849000, longtitude: 118.2426, latitude: 34.0549),
              "San Francisco": CityStatistics(cityName: "San Francisco", population: 815201, longtitude: 122.4194, latitude: 37.7749),
              "Rome": CityStatistics(cityName: "Rome", population: 2873000, longtitude: 12.496366, latitude: 41.902782),
              "London": CityStatistics(cityName: "London", population: 8982000, longtitude: 0.1276, latitude: 51.5072)]

var maxPopulationCity = 0
var maxPopulationCityName = ""
for (k, v) in cities {
    if v.getPopulation() > maxPopulationCity {
        maxPopulationCityName = k
        maxPopulationCity = v.getPopulation()
    }
}
print("Largest Population City is \(maxPopulationCityName) and it's population is \(maxPopulationCity)")

var highestLatitude = -90.0
var mostNorthernCity = ""
for (k, v) in cities {
    if v.getLatitude() > highestLatitude {
        mostNorthernCity = k
        highestLatitude = v.getLatitude()
    }
}
print("Most northern city is \(mostNorthernCity) and it's latitude is \(highestLatitude)")
print()


// Question 7
print("Question 7")
var students : [[String:Any]] = [[ "firstName": "John", "lastName": "Wilson", "gpa": 2.4 ],
                                [ "firstName": "Nancy", "lastName": "Smith", "gpa": 3.5 ],
                                [ "firstName": "Michael", "lastName": "Liu", "gpa": 3.1 ]]

var highestGpa = 0.0
var studentWithHighestGpa: [String: Any]?
for student in students {
    let gpa = student["gpa"] as? Double
    if gpa! > highestGpa {
        highestGpa = gpa!
        studentWithHighestGpa = student
    }
}
print("Student with highest GPA: ", terminator: "")
if let student = studentWithHighestGpa {
    print("First Name: \(student["firstName"] ?? ""), Last Name: \(student["lastName"] ?? "")")
}
print()

