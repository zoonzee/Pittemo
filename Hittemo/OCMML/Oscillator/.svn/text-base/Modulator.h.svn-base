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
//  Modulator.h
//  OCMML
//
//  Created by hkrn on 09/02/03.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#define kTableLength (1 << 16)
#define kPhaseShift 14
#define kPhaseLength (kTableLength << kPhaseShift)
#define kPhaseHalf (kTableLength << (kPhaseShift - 1))
#define kPhaseMask (kPhaseLength - 1)

#if CGFLOAT_IS_DOUBLE
#define kSampleRate 22050.0 // 44100.0
#else
#define kSampleRate 22050.0f // 44100.0f
#endif

#if CGFLOAT_IS_DOUBLE
#define kSampleFrequencyBase 440.0
#else
#define kSampleFrequencyBase 440.0f
#endif

@interface Modulator : NSObject
{
    CGFloat m_frequency;
    int m_frequencyShift;
    int m_phase;
}

- (void)resetPhase;
- (void)addPhase:(int)time;
- (CGFloat)nextSampleFromOffset:(int)offset;
- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end;
- (void)getSamples:(CGFloat *)samples
            syncIn:(const BOOL *)syncIn
             start:(int)start
               end:(int)end;
- (void)getSamples:(CGFloat *)samples
           syncOut:(BOOL *)syncOut
             start:(int)start
               end:(int)end;

@property(readonly) CGFloat nextSample;
@property(assign) CGFloat frequency;

@end
