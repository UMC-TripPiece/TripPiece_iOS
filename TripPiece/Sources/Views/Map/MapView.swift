// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import Macaw

class MapView: MacawView {
    
    override init(frame: CGRect) {
        fatalError("Use init() instead")
    }
    
    public var map: Group
    weak var delegate: MapDelegate?
    
    
    
    
    /// Custom initializer
    init() {
        // SVG 파싱 및 bounds 처리
        guard let svg = try? SVGParser.parse(resource: "world") else {
            fatalError("Failed to parse SVG file")
        }
        guard let bounds = svg.bounds?.toCG() else {
            fatalError("SVG bounds is nil")
        }
        // 👉 SVG의 bounds를 직접 frame으로 설정
        let frame = svg.bounds?.toCG() ?? .zero

        // Map 객체 생성
        self.map = Group(contents: [svg], place: .identity)
            
        // Call UIView's initializer with calculated bounds
        super.init(frame: frame)

        // Node 설정
        self.node = map
        
        // 👉 나라별 터치 이벤트 등록
        for countryEnum in CountryEnum.allCases {
            map.nodeBy(tag: countryEnum.rawValue)?.onTouchPressed({ [weak self] touch in
                self?.delegate?.didSelectCountry(countryEnum)  // Delegate 호출
            })
        }
    }
    
    
    @MainActor required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCountryBounds(country: CountryEnum) -> CGRect? {
        return map.nodeBy(tag: country.rawValue)?.bounds?.toCG()
    }
    
    override func touchesBegan(_ touches: Set<MTouch>, with event: MEvent?) {
        super.touchesBegan(touches, with: event)
        if map.contents.count == 1 {
            // 바다 클릭했을 때
            delegate?.didSelectCountry(nil)
        }
    }
    
    func changeCountryColor(countryEnum: CountryEnum, color: UIColor) {
        // 국가의 Shape 노드를 가져옵니다.
        if let shape = map.nodeBy(tag: countryEnum.rawValue) as? Shape {
            // 기존 shape의 fill 속성을 변경합니다.
            shape.fill = Macaw.Color.from(uiColor: color)
        } else {
            print("\(countryEnum.rawValue) 노드를 찾을 수 없습니다.")
        }
    }
}


