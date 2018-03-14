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
//  FCDPCM.m
//  OCMML
//
//  Created by hkrn on 09/05/16.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "FCDPCM.h"

static unsigned int s_table[kFCDPCMMaxWave][kFCDPCMTableMaxLength];
static int s_intVol[kFCDPCMMaxWave];
static int s_loopFlag[kFCDPCMMaxWave];
static int s_length[kFCDPCMMaxWave];
static int s_interval[] = {
   428, 380, 340, 320, 286, 254, 226, 214, 190, 160, 142, 128, 106,  85,  72,  54
};

@implementation FCDPCM

+ (void)initialize
{
    static BOOL s_initialized = NO;
    if (!s_initialized) {
        [FCDPCM setWaveWithIndex:0
                          intVol:127
                        loopFlag:0
                      waveString:@""];
        s_initialized = YES;
    }
}

+ (void)setWaveWithIndex:(int)aIndex
                  intVol:(int)intVol
                loopFlag:(int)loopFlag
              waveString:(NSString *)wave
{
    aIndex = MIN(MAX(aIndex, 0), kFCDPCMMaxWave - 1);
    s_intVol[aIndex] = MIN(MAX(intVol, 0), 127);
    s_loopFlag[aIndex] = MIN(MAX(loopFlag, 0), 1);
    s_length[aIndex] = 0;
    int pos = 0, count = 0, count2 = 0;
    NSUInteger waveLength = [wave length];
    for (NSUInteger i = 0; i < waveLength; i++) {
        int code = 0;
        unichar c = [wave characterAtIndex:i];
        if (0x41 <= c && c <= 0x5a) {
            code -= 0x41;
        }
        else if (0x61 <= c && c <= 0x7a) {
            code -= 0x61 - 26;
        }
        else if (0x30 <= c && c <= 0x39) {
            code -= 0x30 - 26 - 26;
        }
        else if (code == 0x2b) {
            code = 26 + 26 + 10;
        }
        else if (code == 0x2f) {
            code = 26 + 26 + 10 + 1;
        }
        else if (code == 0x3d) {
            code = 0;
        }
        else {
            code = 0;
        }
        for (int j = 5; j >= 0; j--) {
            s_table[aIndex][pos] += ((code >> j) & 1) << (count * 8 + 8 - count2);
            count2++;
            if (count2 >= 8) {
                count2 = 0;
                count++;
            }
            s_length[aIndex]++;
            if (count >= 4) {
                count = 0;
                pos++;
                if (pos >= kFCDPCMTableMaxLength)
                    pos = kFCDPCMTableMaxLength - 1;
            }
        }
    }
    int length = s_length[aIndex];
    length -= ((length - 8) % 0x80);
    length = MIN(length, kFCDPCMTableMaxLength * 8);
    if (length == 0) {
        length = 8;
    }
    s_length[aIndex] = length;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self resetPhase];
        [self setWaveIndex:0];
        self.frequency = kSampleFrequencyBase;
    }
    return self;
}

#if CGFLOAT_IS_DOUBLE
#define FCDPCMGetValue() ((m_wave - 64) / 64.0)
#else
#define FCDPCMGetValue() ((m_wave - 64) / 64.0f)
#endif

- (void)getSample:(CGFloat *)value
{
    while (kFCDPCMNext <= m_phase) {
        m_phase -= kFCDPCMNext;
        if (m_length > 0) {
            if ((s_table[m_index][m_address] >> m_bit) & 1) {
                if (m_wave < 126) {
                    m_wave += 2;
                }
            }
            else {
                if (m_wave > 1) {
                    m_wave -= 2;
                }
            }
            m_bit++;
            if (m_bit >= 32) {
                m_bit = 0;
                m_address++;
            }
            m_length--;
            if (m_length == 0) {
                if (s_loopFlag[m_index] > 0) {
                    m_address = 0;
                    m_bit = 0;
                    m_length = s_length[m_index];
                }
            }
        }
        *value = FCDPCMGetValue();
    }
}

- (void)resetPhase
{
    m_phase = 0;
    m_address = 0;
    m_bit = 0;
    m_offset = 0;
    m_wave = s_intVol[m_index];
    m_length = s_length[m_index];
}

- (CGFloat)nextSample
{
    CGFloat value = FCDPCMGetValue();
    [self addPhase:1];
    [self getSample:&value];
    return value;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    CGFloat value = FCDPCMGetValue();
    m_phase = (m_phase + m_frequencyShift + ((offset - m_offset) >> (kPhaseShift - 7))) & kPhaseMask;
    [self getSample:&value];
    m_offset = offset;
    return value;
}

#undef FCDPCMGetValue

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = [self nextSample];
    }
}

- (void)setWaveIndex:(int)waveIndex
{
    m_index = MIN(MAX(waveIndex, 0), (kFCDPCMMaxWave - 1));
}

- (void)setFrequency:(CGFloat)frequency
{
    m_frequencyShift = (int)(frequency * (1 << (kFCDPCMPhaseShift + 4)));
}

- (void)setDPCMFrequency:(int)aIndex
{
    aIndex = MIN(MAX(aIndex, 0), (kFCDPCMMaxWave - 1));
    m_frequencyShift = (kFCDPCMCPUCycle << kFCDPCMPhaseShift) / s_interval[aIndex];
}

@end
