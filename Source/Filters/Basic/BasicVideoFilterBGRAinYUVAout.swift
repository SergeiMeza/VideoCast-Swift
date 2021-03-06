//
//  BasicVideoFilterBGRAinYUVAout.swift
//  VideoCast
//
//  Created by Tomohiro Matsuzawa on 2018/02/13.
//  Copyright © 2018年 CyberAgent, Inc. All rights reserved.
//

import Foundation
import GLKit

open class BasicVideoFilterBGRAinYUVAout: BasicVideoFilter {
    internal static let isRegistered = registerFilter()

    #if targetEnvironment(simulator) || arch(arm)
    open override var pixelKernel: String? {
        return kernel(language: .GL_ES2_3, target: filterLanguage, kernelstr: """
precision mediump float;
varying vec2      vCoord;
uniform sampler2D uTex0;
const mat4 RGBtoYUV(0.257,  0.439, -0.148, 0.0,
             0.504, -0.368, -0.291, 0.0,
             0.098, -0.071,  0.439, 0.0,
             0.0625, 0.500,  0.500, 1.0 );
void main(void) {
    gl_FragData[0] = texture2D(uTex0, vCoord) * RGBtoYUV;
}
""")
    }
    #else
    open override var fragmentFunc: String {
        return "bgra2yuva_fragment"
    }
    #endif

    open override var name: String {
        return "jp.co.cyberagent.VideoCast.filters.bgra2yuva"
    }

    #if !targetEnvironment(simulator) && !arch(arm)
    open override var piplineDescripter: String? {
        return "bgra2yuvaPiplineState"
    }
    #endif

    private static func registerFilter() -> Bool {
        FilterFactory.register(
            name: "jp.co.cyberagent.VideoCast.filters.bgra2yuva",
            instantiation: { return BasicVideoFilterBGRAinYUVAout() }
        )
        return true
    }
}
