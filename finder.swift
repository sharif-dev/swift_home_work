import Foundation

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
