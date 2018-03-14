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
//  FCNoise.m
//  OCMML
//
//  Created by hkrn on 09/02/03.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "FCNoise.h"

@implementation FCNoise

static int s_interval[16] = {
0x004, 0x008, 0x010, 0x020, 0x040, 0x060, 0x080, 0x0a0,
0x0ca, 0x0fe, 0x17c, 0x1fc, 0x2fa, 0x3f8, 0x7f2, 0xfe4
};

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self setLongMode];
        m_fcr = 0x8000;
        m_value = self.value;
        [self setNoiseFrequency:0];
    }
    return self;
}

- (CGFloat)value
{
    m_fcr >>= 1;
    m_fcr |= ((m_fcr ^ (m_fcr >> m_snz)) & 1) << 15;
#if CGFLOAT_IS_DOUBLE
    return (m_fcr & 1) ? 1.0 : -1.0;
#else
    return (m_fcr & 1) ? 1.0f : -1.0f;
#endif
}

- (void)setShortMode
{
    m_snz = 6;
}

- (void)setLongMode
{
    m_snz = 1;
}

- (void)setNoiseFrequency:(int)noise
{
    noise = MIN(MAX(noise, 0), 15);
    m_frequencyShift = s_interval[noise] << kFCNoisePhaseShift;
}

- (void)resetPhase
{
    return;
}

- (void)addPhase:(int)aTime
{
    m_phase = m_phase + kFCNoisePhaseDelta * aTime;
    while (m_phase >= m_frequencyShift) {
        m_phase -= m_frequencyShift;
        m_value = self.value;
    }
}

- (void)nextSampleFromOffsetDelta:(int)delta
{
    CGFloat sum = 0;
    CGFloat count = 0;
    while (delta >= m_frequencyShift) {
        delta -= m_frequencyShift;
        m_phase = 0;
        sum += self.value;
#if CGFLOAT_IS_DOUBLE
        count += 1.0;
#else
        count += 1.0f;
#endif
    }
    if (count > 0) {
        m_value = sum / count;
    }
    m_phase += delta;
}

- (CGFloat)nextSample
{
    CGFloat value = m_value;
    int delta = kFCNoisePhaseDelta;
    [self nextSampleFromOffsetDelta:delta];
    if (m_phase >= m_frequencyShift) {
        m_phase -= m_frequencyShift;
        m_value = self.value;
    }
    return value;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    int fcr = m_fcr;
    int phase = m_phase;
    CGFloat value = m_value;
    int delta = kFCNoisePhaseDelta + offset;
    [self nextSampleFromOffsetDelta:delta];
    if (m_phase >= m_frequencyShift) {
        m_phase = m_frequencyShift;
        m_value = self.value;
    }
    m_fcr = fcr;
    m_phase = phase;
    (void)self.nextSample;
    return value;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = self.nextSample;
    }
}

- (void)setFrequency:(CGFloat)frequency
{
    m_frequencyShift = (int)(kFCNoisePhaseSecond / frequency);
}

@end
