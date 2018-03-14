/*
 Copyright (c) 2009, hkrn All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. Redistributions in binary
 form must reproduce the above copyright notice, this list of conditions and
 the following disclaimer in the documentation and/or other materials
 provided with the distribution. Neither the name of the hkrn nor
 the names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission. 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 DAMAGE.
 */

//
//  MMLOscillator.h
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

enum MMLOscillatorType {
    kMMLOscillatorSine = 0,        // 0   正弦波
    kMMLOscillatorSaw,            // 1   ノコギリ波
    kMMLOscillatorTriangle,        // 2   三角波
    kMMLOscillatorPulse,        // 3   変調波
    kMMLOscillatorNoise,        // 4   ノイズ
    kMMLOscillatorFCPulse,        // 5   ファミコンの変調波
    kMMLOscillatorFCTriangle,    // 6   ファミコンの三角波
    kMMLOscillatorFCNoise,        // 7   ファミコンのノイズ
    kMMLOscillatorFCShortNoise,    // 8   ファミコンのショートノイズ
    kMMLOscillatorFCDPCM,        // 9   ファミコンの何か
    kMMLOscillatorGBWave,        // 10  ゲームボーイのノイズ
    kMMLOscillatorGBLongNoise,    // 11  ゲームボーイのノイズ
    kMMLOscillatorGBShortNoise,    // 12  ゲームボーイのショートノイズ
    kMMLOscillatorMax            // 13  使われない。境界線
};

@class Modulator;

@interface MMLOscillator : NSObject
{
    enum MMLOscillatorType m_form;
    Modulator *m_oscillators[kMMLOscillatorMax];
}

- (Modulator *)modulatorFromForm:(enum MMLOscillatorType)form;
- (void)asLFO;

@property enum MMLOscillatorType form;
@property(readonly) Modulator *currentModulator;

@end
