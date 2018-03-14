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
//  Pulse.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Pulse.h"

@implementation Pulse

- (id)init
{
    self = [super init];
    if (self != nil) {
#if CGFLOAT_IS_DOUBLE
        [self setPWM:0.5];
#else
        [self setPWM:0.5f];
#endif
    }
    return self;
}

- (CGFloat)nextSample
{
    CGFloat value = m_phase < m_pwm ? 1 : -1;
    [self addPhase:1];
    return value;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    CGFloat value = ((m_phase + offset) & kPhaseMask) < m_pwm ? 1 : -1;
    [self addPhase:1];
    return value;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = m_phase < m_pwm ? 1 : -1;
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
        samples[i] = m_phase < m_pwm ? 1 : -1;
        [self addPhase:1];
    }
}

- (void)getSamples:(CGFloat *)samples
           syncOut:(BOOL *)syncOut
             start:(int)start
               end:(int)end
{
    for (int i = start; i < end; i++) {
        samples[i] = m_phase < m_pwm ? 1 : -1;
        m_phase += m_frequencyShift;
        syncOut[i] = (m_phase > kPhaseMask);
        m_phase &= kPhaseMask;
    }
}

- (void)setPWM:(CGFloat)pwm
{
    m_pwm = (int)(pwm * kPhaseLength);
}

@end
