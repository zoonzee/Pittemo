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
//  GBWave.m
//  OCMML
//
//  Created by hkrn on 09/02/04.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "GBWave.h"

@implementation GBWave

static CGFloat s_table[kMaxWave][kGBWaveTableLength];

+ (void)initialize
{
    static BOOL s_initialized = NO;
    if (!s_initialized) {
        [GBWave setWaveString:@"0123456789abcdeffedcba9876543210" no:0];
        s_initialized = YES;
    }
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self setWaveIndex:0];
    }
    return self;
}

- (CGFloat)nextSample
{
    CGFloat value = s_table[m_waveIndex][m_phase >> (kPhaseShift + 11)];
    [self addPhase:1];
    return value;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    CGFloat value = s_table[m_waveIndex][((m_phase + offset) & kPhaseMask) >> (kPhaseShift + 11)];
    [self addPhase:1];
    return value;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = s_table[m_waveIndex][m_phase >> (kPhaseShift + 11)];
        [self addPhase:1];
    }
}


- (void)getSamples:(CGFloat *)samples
            syncIn:(const BOOL *)syncIn
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        if (syncIn[i]) {
            [self resetPhase];
        }
        samples[i] = s_table[m_waveIndex][m_phase >> (kPhaseShift + 11)];
        [self addPhase:1];
    }
}

- (void)getSamples:(CGFloat *)samples
           syncOut:(BOOL *)syncOut
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = s_table[m_waveIndex][m_phase >> (kPhaseShift + 11)];
        m_phase += m_frequencyShift;
        syncOut[i] = (m_phase > kPhaseMask);
        m_phase &= kPhaseMask;
    }
}

- (void)setWaveIndex:(int)waveIndex
{
    m_waveIndex = MIN(MAX(waveIndex, 0), kMaxWave - 1);
}

+ (void)setWaveString:(NSString *)aWave
                   no:(int)waveIndex
{
    int i = 0;
    NSUInteger pos = 0, length = [aWave length];
    NSString *wave = [aWave lowercaseString];
    waveIndex = MIN(MAX(waveIndex, 0), kMaxWave - 1);
    while (i < kGBWaveTableLength) {
        int code = [wave characterAtIndex:pos++];
        if (isspace(code)) {
            continue;
        }
        else if (length <= pos) {
            break;
        }
        else if (48 <= code && code < 58) {
            code -= 48;
        }
        else if (97 <= code && code < 103) {
            code -= 97 - 10;
        }
        else {
            code = 0;
        }
        CGFloat n = 0;
#if CGFLOAT_IS_DOUBLE
        n = (code - 7.5) / 7.5;
#else
        n = (code - 7.5f) / 7.5f;
#endif
        s_table[waveIndex][i] = n;
        i++;
    }
}

@end
