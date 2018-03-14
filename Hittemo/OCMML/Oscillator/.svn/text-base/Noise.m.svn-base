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
//  Noise.m
//  OCMML
//
//  Created by hkrn on 09/02/04.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Noise.h"

@implementation Noise

static CGFloat s_table[kTableLength];

@synthesize shouldResetPhase;

+ (void)initialize
{
    static BOOL s_initialized = NO;
    if (!s_initialized) {
        srand((unsigned)time(NULL));
        CGFloat den = RAND_MAX + 1.0f;
        for (int i = 0; i < kTableLength; i++) {
            s_table[i] = (rand() / den) * 2 - 1;
        }
        s_initialized = YES;
    }
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self setNoiseFrequency:1];
        m_phase = 0;
        m_counter = 0;
        shouldResetPhase = YES;
    }
    return self;
}

- (void)resetPhase
{
    if (shouldResetPhase) {
        m_phase = 0;
    }
    //counter = 0;
}

- (void)addPhase:(int)aTime
{
    m_counter = m_counter + m_frequencyShift * aTime;
    m_phase = (m_phase + (m_counter >> kNoisePhaseShift)) & kNoiseTableMask;
    m_counter &= kNoisePhaseMask;
}

- (CGFloat)nextSample
{
    CGFloat value = s_table[m_phase];
    [self addPhase:1];
    return value;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    CGFloat value = s_table[(m_phase + (offset << kPhaseShift)) & kNoiseTableMask];
    [self addPhase:1];
    return value;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = s_table[m_phase];
        [self addPhase:1];
    }
}

- (void)setFrequency:(CGFloat)frequency
{
    m_frequency = frequency;
}

- (void)setNoiseFrequency:(CGFloat)frequency
{
    m_noiseFrequency = frequency * (1 << kNoisePhaseShift);
    m_frequencyShift = (int)m_noiseFrequency;
}

- (void)restoreFrequency
{
    m_frequencyShift = (int)m_noiseFrequency;
}

@end
