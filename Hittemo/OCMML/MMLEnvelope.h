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
//  MMLEnvelope.h
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#define kEngineMaxPipe 3

@interface MMLEnvelope : NSObject
{
    int m_attackTime;
    CGFloat m_attackRcpr;
    int m_decayTime;
    CGFloat m_decayRcpr;
    CGFloat m_sustainLevel;
    CGFloat m_releaseTime;
@private
    CGFloat m_currentValue;
    CGFloat m_releaseStep;
    BOOL m_releasing;
    BOOL m_playing;
    int m_timeInSamples;
    CGFloat m_startAmplitude;
}

- (id)initWithAttack:(CGFloat)attack
               decay:(CGFloat)decay
             sustain:(CGFloat)sustain
             release:(CGFloat)release;
- (void)setAttack:(CGFloat)attack
            decay:(CGFloat)decay
          sustain:(CGFloat)sustain
          release:(CGFloat)release;
- (void)triggerWithZeroStart:(BOOL)zeroStart;
- (void)releaseEnvelope;
- (void)getAmplitudeSamplesLinear:(CGFloat *)samples
                            start:(int)start
                              end:(int)end
                         velocity:(CGFloat)velocity;
- (void)getAmplitudeSamplesNonLinear:(CGFloat *)samples
                               start:(int)start
                                 end:(int)end
                            velocity:(CGFloat)velocity;

@property(readonly) CGFloat nextAmplitudeLinear;
@property(readonly) BOOL playing;

@end
