// Copyright © 2024 TripPiece. All rights reserved

import UIKit
import Macaw

class MapView: MacawView {
    
    override init(frame: CGRect) {
        fatalError("Use init() instead")
    }
    
    public var map: Group
    //weak var delegate: MapViewDelegate?
    
    
    /// Custom initializer
    init() {
        // SVG 파싱 및 bounds 처리
        guard let svg = try? SVGParser.parse(resource: "world") else {
            fatalError("Failed to parse SVG file")
        }
        guard let bounds = svg.bounds?.toCG() else {
            fatalError("SVG bounds is nil")
        }

        // Map 객체 생성
        self.map = Group(contents: [svg], place: .identity)
            
        // Call UIView's initializer with calculated bounds
        super.init(frame: bounds)

        // Node 설정
        self.node = map
    }
    
    /*override init(frame: CGRect) {
        map = Group()
        
        guard let svg = try? SVGParser.parse(resource: "world") else {
            fatalError("failed to parse svg file")
        }
        
        // svg.bounds가 nil인지 확인
        guard let bounds = svg.bounds?.toCG() else {
            fatalError("SVG bounds is nil")
        }
        
        super.init(frame: bounds)
        map = Group(contents: [svg], place: .identity)
        self.node = map
        
        /*for countryEnum in CountryEnum.allCases {
            map.nodeBy(tag: countryEnum.rawValue)?.onTouchPressed({ [weak self] touch in
                //self?.delegate?.onClick(country: countryEnum)
                self?.changeCountryColor(countryEnum: countryEnum, color: .blue)
                        
                        /*if let shape = touch.node as? Shape {
                            shape.fill = Color.blue
                            let select: Shape = Shape(
                                form: shape.form,
                                stroke: shape.stroke,
                                place: shape.place,
                                clip: shape.clip
                            )
                            self?.map.contents.append(select)
                        }*/
                })
            }*/
    }*/
    
    @MainActor required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
