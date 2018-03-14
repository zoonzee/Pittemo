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
//  Modulator.m
//  OCMML
//
//  Created by hkrn on 09/02/03.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Modulator.h"

@implementation Modulator

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self resetPhase];
        m_frequency = kSampleFrequencyBase;
    }
    return self;
}

- (void)resetPhase
{
    m_phase = 0;
}

- (void)addPhase:(int)aTime
{
    m_phase = (m_phase + m_frequencyShift * aTime) & kPhaseMask;
}

- (CGFloat)nextSample
{
    return 0;
}

- (CGFloat)nextSampleFromOffset:(int)offset
{
    return 0;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    return;
}

- (void)getSamples:(CGFloat *)samples
            syncIn:(const BOOL *)syncIn
             start:(int)start
               end:(int)end;
{
    [self getSamples:samples
               start:start
                 end:end];
}

- (void)getSamples:(CGFloat *)samples
           syncOut:(BOOL *)syncOut
             start:(int)start
               end:(int)end;
{
    [self getSamples:samples
               start:start
                 end:end];
}

- (CGFloat)frequency
{
    return m_frequency;
}

- (void)setFrequency:(CGFloat)frequency
{
    m_frequency = frequency;
    m_frequencyShift = (int)(frequency * (kPhaseLength / kSampleRate));
}

@end
