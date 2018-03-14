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
//  GBShortNoise.m
//  OCMML
//
//  Created by hkrn on 09/02/04.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "GBShortNoise.h"

@implementation GBShortNoise

static int s_table[kGBShortNoiseTableLength];
static int s_interval[] = {
0x000002, 0x000004, 0x000008, 0x00000c, 0x000010, 0x000014, 0x000018, 0x00001c,
0x000020, 0x000028, 0x000030, 0x000038, 0x000040, 0x000050, 0x000060, 0x000070,
0x000080, 0x0000a0, 0x0000c0, 0x0000e0, 0x000100, 0x000140, 0x000180, 0x0001c0,
0x000200, 0x000280, 0x000300, 0x000380, 0x000400, 0x000500, 0x000600, 0x000700,
0x000800, 0x000a00, 0x000c00, 0x000e00, 0x001000, 0x001400, 0x001800, 0x001c00,
0x002000, 0x002800, 0x003000, 0x003800, 0x004000, 0x005000, 0x006000, 0x007000,
0x008000, 0x00a000, 0x00c000, 0x00e000, 0x010000, 0x014000, 0x018000, 0x01c000,
0x020000, 0x028000, 0x030000, 0x038000, 0x040000, 0x050000, 0x060000, 0x070000
};

+ (void)initialize
{
    static BOOL s_initialized = NO;
    if (!s_initialized) {
        unsigned int gbr = 0xffff;
        unsigned int output = 1;
        for (int i = 0; i < kGBShortNoiseTableLength; i++) {
            if (gbr == 0) {
                gbr = 1;
            }
            gbr += gbr + (((gbr >> 6) ^ (gbr >> 5)) & 1);
            output ^= gbr & 1;
            s_table[i] = output * 2 - 1;
        }
        s_initialized = YES;
    }
}


#if CGFLOAT_IS_DOUBLE
#define N1_0 1.0
#else
#define N1_0 1.0f
#endif

- (CGFloat)nextSample
{
    CGFloat value = s_table[m_phase >> (kGBShortNoisePhaseShift)];
    if (m_skip > 0) {
        value = (value + m_sum) / (m_skip + N1_0);
    }
    m_sum = m_skip = 0;
    int frequencyShift = m_frequencyShift;
    while (frequencyShift > kGBShortNoisePhaseDelta) {
        m_phase = (m_phase + kGBShortNoisePhaseDelta) % kGBShortNoiseTableMod;
        frequencyShift -= kGBShortNoisePhaseDelta;
        m_sum += s_table[m_phase >> kGBShortNoisePhaseShift];
        m_skip++;
    }
    m_phase = (m_phase + frequencyShift) % kGBShortNoiseTableMod;
    return value;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    CGFloat value = s_table[((m_phase + offset) % kGBShortNoiseTableMod) >> (kGBShortNoisePhaseShift)];
    m_phase = (m_phase + m_frequencyShift) % kGBShortNoiseTableMod;
    return value;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        CGFloat value = s_table[m_phase >> kGBShortNoisePhaseShift];
        if (m_skip > 0) {
            value = (value + m_sum) / (m_skip + N1_0);
        }
        samples[i] = value;
        m_sum = m_skip = 0;
        int frequencyShift = m_frequencyShift;
        while (frequencyShift > kGBShortNoisePhaseDelta) {
            m_phase = (m_phase + kGBShortNoisePhaseDelta) % kGBShortNoiseTableMod;
            frequencyShift -= kGBShortNoisePhaseDelta;
            m_sum += s_table[m_phase >> kGBShortNoisePhaseShift];
            m_skip++;
        }
        m_phase = (m_phase + frequencyShift) % kGBShortNoiseTableMod;
    }
}

#undef N1_0

- (void)setFrequency:(CGFloat)frequency
{
    m_frequency = frequency;
}

- (void)setNoiseFrequency:(int)anIndex
{
    anIndex = MIN(MAX(anIndex, 0), 63);
    m_frequencyShift = (1048576 << (kGBShortNoisePhaseShift - 2)) / (s_interval[anIndex] * 11025);
}

@end
