// syntax highlighting can be quite hard ... lol
// especially with ordering... need semantic analyzer !!!!

Student:
  // student_id: String

  apply: (name: String) -> String
    "{name}--{random.next}"

  extract: (string: String) -> String
    arr: string.split "--" // type [String]
    (not arr.tail.empty) ? Exists (arr.head) : None

student: Student "Sukyoung"  // Sukyoung--23098234908
match student
  Student name => println name  // prints Sukyoung
  else => println "Could not extract a CustomerID"

// c++ uses `operator ()`

// here we want either apply or extract
// or just the name itself like

// trait Extract[T] {
//   fn extract(s: String) -> Option[T];
// }

// trait Apply[T] {
//   fn apply(t: T) -> String;
// }

// order does matter, if you have T: Type you can reference that after it, but prob not before it...
// syntax sugar for type parameters
// Extract: trait <In, Res> (In) -> Res?

// meta parameter!

Extract: trait (In: Type, Res: Type) (In) -> Res?
Apply: trait (In: Type, Res: Type) (In) -> Res

Student: impl Apply (string: String) -> String => "{name}--{random.next}"

Student: impl Extract (name: String) -> String?
  arr: string.split "--"
  (not arr.tail.empty) ? Exists (arr.head) : None


// Type references
// struct TypeReference <: SemanticObject
//   typename::Identifier
// end
// IDK tbh. I think it could work, but maybe it should also point to an actual semantic object as well

// could also just use a separate index as well but idk
