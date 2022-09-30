//
//  Plan.swift
//  ch09-tableView-student
//
//  Created by iOSprogramming on 2022/04/27.
//

import Foundation

class Plan: NSObject ,NSCoding{
    enum Kind: Int {
        case Todo = 0, Meeting, Study, Etc
        func toString() -> String{
            switch self {
            case .Todo: return "할일";     case .Meeting: return "미팅"
            case .Study: return "공부";    case .Etc: return "기타"
            }
        }
        static var count: Int { return Kind.Etc.rawValue + 1}
    }
    
    var key: String;        var date: Date
    var owner: String?;     var kind: Kind
    
    var content: String
    var content2: String
    var content3: String
    var content4: String
    var content5: String
    var content6: String
    
    init(date: Date, owner: String?, kind: Kind, content: String){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
        self.date = Date(timeInterval: 0, since: date)
        self.owner = "💙"+Owner.getOwner()+"님💙"
        self.kind = kind
        self.content = content
        self.content2 = content+"m"
        self.content3 = content+"m"
        self.content4 = content+"m"
        self.content5 = content+"m"
        self.content6 = content
        super.init()
    }
    
    // archiving할때 호출된다
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key") // 내부적으로 String의 encode가 호출된다
        aCoder.encode(date, forKey: "date")
        aCoder.encode(owner, forKey: "owner")
        aCoder.encode(kind.rawValue, forKey: "kind")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(content2, forKey: "content2")
        aCoder.encode(content3, forKey: "content3")
        aCoder.encode(content4, forKey: "content4")
        aCoder.encode(content5, forKey: "content5")
        aCoder.encode(content6, forKey: "content6")
        
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        date = aDecoder.decodeObject(forKey: "date") as! Date
        owner = aDecoder.decodeObject(forKey: "owner") as? String
        let rawValue = aDecoder.decodeInteger(forKey: "kind")
        kind = Kind(rawValue: rawValue)!
        content = aDecoder.decodeObject(forKey: "content") as! String? ?? ""
        content2 = aDecoder.decodeObject(forKey: "content2") as! String? ?? ""
        content3 = aDecoder.decodeObject(forKey: "content3") as! String? ?? ""
        content4 = aDecoder.decodeObject(forKey: "content4") as! String? ?? ""
        content5 = aDecoder.decodeObject(forKey: "content5") as! String? ?? ""
        content6 = aDecoder.decodeObject(forKey: "content6") as! String? ?? ""
        
        super.init()
        
    }
}
extension Plan{
    convenience init(date: Date? = nil, withData: Bool = false){
        if withData == true{
            var index = Int(arc4random_uniform(UInt32(Kind.count)))
            let kind = Kind(rawValue: index)! // 이것의 타입은 옵셔널이다. Option+click해보라
            
            let contents = ["iOS 숙제", "졸업 프로젝트", "아르바이트","데이트","엄마 도와드리기"]
            index = Int(arc4random_uniform(UInt32(contents.count)))
            let content = contents[index]
            
            self.init(date: date ?? Date(), owner: "me", kind: kind, content: content)
            
        }else{
            self.init(date: date ?? Date(), owner: "me", kind: .Etc, content: "")
            
        }
    }
}

extension Plan{ // Plan.swift
    func clone() -> Plan {
        let clonee = Plan()
        
        clonee.key = self.key // key는 String이고 String은 struct이다. 따라서 복제가 된다
        clonee.date = Date(timeInterval: 0, since: self.date) // Date는 struct가 아니라 class이기 때문
        
        clonee.owner = "💙"+Owner.getOwner()+"님💙"
        clonee.kind = self.kind // enum도 struct처럼 복제가 된다
        clonee.content = self.content
        clonee.content2 = self.content2
        clonee.content3 = self.content3
        clonee.content4 = self.content4
        clonee.content5 = self.content5
        clonee.content6 = self.content6
        return clonee
    }
}
