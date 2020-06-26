import Foundation

let deltas = [
  (dr: -1, dc: -1),
  (dr: -1, dc: 0),
  (dr: -1, dc: 1),
  (dr: 0, dc: -1),
  (dr: 0, dc: 1),
  (dr: 1, dc: -1),
  (dr: 1, dc: 0),
  (dr: 1, dc: 1)
  ]

struct Coordinate: Hashable {
  let row: Int
  let col: Int
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

class TrieNode {
  var letter: Character
  var children: 
  Dictionary<Character, TrieNode>
  var father: TrieNode?
  var whole = false
  
  init(letter: Character, father: TrieNode?) {
      self.letter = letter
      self.father = father
      self.children = Dictionary<Character, TrieNode>()
      self.whole = false
  }

  func traverse(indentCount: Int){
    print(String(repeating: "\t", count: indentCount), terminator: "")
    print(self.letter, terminator: "")
    if(self.whole){
      print(".")
    }else{
      print()
    }
  
    if(self.children.isEmpty){
      return
    }
    for key in self.children.keys{
      self.children[key]!.traverse(indentCount: indentCount + 1)
    }
  }

  func getWords(m: Int, n: Int, letterDictionary: inout Dictionary<Character, Set<Coordinate>>, current: String){
    if self.whole{
      if(findString(m: m, n: n, letterDictionary: &letterDictionary, from: nil, visiteds: Set<Coordinate>(), str: current + String(self.letter))){
        print(current + String(self.letter))
      }
    }
    for key in self.children.keys{
      self.children[key]!.getWords(m: m, n: n, letterDictionary: &letterDictionary, current: current + String(self.letter))
    }
  }
}
class Trie {
  var root: TrieNode
  init(words: [String]){
    self.root = TrieNode(letter: "#", father: nil)
    for word in words{
      var current: TrieNode = root
      var counter = 0
      for char in word{
        if(current.children[char] == nil){
          current.children[char] = TrieNode(letter: char, father: current)
        }
        current = current.children[char]!
        if counter == word.count - 1 {
          current.whole = true
        }
        counter += 1
      }
    }
  }
    func getWords(m: Int, n: Int, letterDictionary: inout Dictionary<Character, Set<Coordinate>>){
    for key in self.root.children.keys{
      root.children[key]!.getWords(m: m, n: n, letterDictionary: &letterDictionary, current: "")
    }
  }

}



func getNeighbors(m: Int, n: Int, point: Coordinate) -> Set<Coordinate>{
  var result = Set<Coordinate>()
  for delta in deltas{
    if(point.col + delta.dc >= 0 && point.col + delta.dc < n
      && point.row + delta.dr >= 0 && point.row + delta.dr < m){
      result.insert(Coordinate(row: point.row + delta.dr, col: point.col + delta.dc))
    }
  }
  return result
}

func findString(m: Int, n: Int, letterDictionary: inout Dictionary<Character, Set<Coordinate>>, from: Coordinate?, visiteds: Set<Coordinate>, str: String) -> Bool{
  if(str.count == 0){
    return true
  }
  let firstChar = Character(str[0])
  if(letterDictionary[firstChar] == nil){
    return false
  }
  var points = letterDictionary[firstChar]!
  if(from != nil){
    points = points.intersection(getNeighbors(m: m, n: n, point: from!))
  }
  points = points.subtracting(visiteds)
  if(points.count == 0){
    return false
  }
  var res = false
  for point in points{
    var newVisiteds = visiteds
    newVisiteds.insert(point)
    res = res || findString(m: m, n: n, letterDictionary: &letterDictionary, from: point, visiteds: newVisiteds, str: str[1..<str.count])
  }
  return res
}


var words = readLine()!.components(separatedBy: " ")
var trie = Trie(words: words)
var letterLocations = Dictionary<Character, Set<Coordinate>>()
var mn = readLine()!.components(separatedBy: " ")
var m = Int(mn[0])!
var n = Int(mn[1])!
var table = Array(repeating: Array(repeating: Character("#"), count: n), count: m)
for i in 0...m-1{
  var row = readLine()!.components(separatedBy: " ")
  for j in 0...n-1{
    table[i][j] = Character(row[j])
    if(letterLocations[Character(row[j])] == nil){
      letterLocations[Character(row[j])] = Set<Coordinate>()
    }
    letterLocations[Character(row[j])]!.insert(Coordinate(row: i, col: j))
  }
}
trie.getWords(m: m, n: n, letterDictionary: &letterLocations)



