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
//  MMLEnvelope.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLEnvelope.h"
#import "MMLEnvelope+Private.h"

@implementation MMLEnvelope

+ (void)initialize
{
    static BOOL s_initialized = NO;
    if (!s_initialized) {
        s_envelopeVolumeMap[0] = 0;
        for (int i = 0; i < s_envelopeVolumeLength; i++) {
#if CGFLOAT_IS_DOUBLE
            s_envelopeVolumeMap[i] = pow(10.0, (i - 255.0) * (48.0 / (255.0 * 20.0)));
#else
            s_envelopeVolumeMap[i] = powf(10.0f, (i - 255.0f) * (48.0f / (255.0f * 20.0f)));
#endif
        }
        s_initialized = YES;
    }
}

- (id)initWithAttack:(CGFloat)attack
               decay:(CGFloat)decay
             sustain:(CGFloat)sustain
             release:(CGFloat)release
{
    self = [self init];
    if (self != nil) {
        m_playing = NO;
        [self setAttack:attack
                  decay:decay
                sustain:sustain
                release:release];
        m_releasing = YES;
        m_releaseStep = 0;
    }
    return self;
}

#if CGFLOAT_IS_DOUBLE
#define N1_0 1.0
#else
#define N1_0 1.0f
#endif

- (void)setAttack:(CGFloat)attack
            decay:(CGFloat)decay
          sustain:(CGFloat)sustain
          release:(CGFloat)release
{
    if (attack != 0.0) {
        m_attackTime = (int)(attack * kSampleRate);
        m_attackRcpr = N1_0 / m_attackTime;
    }
    if (decay != 0.0) {
        m_decayTime = (int)(decay * kSampleRate);
        m_decayRcpr = N1_0 / m_decayTime;
    }
    m_sustainLevel = sustain;
    m_releaseTime = (release > 0 ? release : (N1_0 / 127)) * kSampleRate;
}

- (void)triggerWithZeroStart:(BOOL)zeroStart
{
    m_playing = YES;
    m_releasing = NO;
    m_startAmplitude = zeroStart ? 0 : m_currentValue;
    m_timeInSamples = 1;
}

- (void)releaseEnvelope
{
    m_releasing = YES;
    m_releaseStep = m_currentValue / m_releaseTime;
}

- (void)updateCurrentValue
{
    if (!m_releasing) {
        if (m_timeInSamples < m_attackTime) {
            m_currentValue = m_startAmplitude + (N1_0 - m_startAmplitude) * m_timeInSamples * m_attackRcpr;
        }
        else if (m_timeInSamples < m_attackTime + m_decayTime) {
            m_currentValue = N1_0 - ((m_timeInSamples - m_attackTime) * m_decayRcpr) * (N1_0 - m_sustainLevel);
        }
        else {
            m_currentValue = m_sustainLevel;
        }
    }
    else {
        m_currentValue -= m_releaseStep;
    }
    if (m_currentValue <= 0) {
        m_playing = NO;
        m_currentValue = 0;
    }
    ++m_timeInSamples;
}

- (CGFloat)nextAmplitudeLinear
{
    if (!m_playing)
        return 0;
    [self updateCurrentValue];
    return m_currentValue;    
}

- (void)getAmplitudeSamplesLinear:(CGFloat *)samples
                            start:(int)start
                              end:(int)end
                         velocity:(CGFloat)velocity
{
    for (int i = start; i < end; i++) {
        if (!m_playing) {
            samples[i] = 0;
            continue;
        }
        CGFloat n = samples[i];
        [self updateCurrentValue];
        samples[i] = n * m_currentValue * velocity;
    }
}

- (void)getAmplitudeSamplesNonLinear:(CGFloat *)samples
                               start:(int)start
                                 end:(int)end
                            velocity:(CGFloat)velocity
{
    for (int i = start; i < end; i++) {
        if (!m_playing) {
            samples[i] = 0;
            continue;
        }
        CGFloat n = samples[i];
        [self updateCurrentValue];
        samples[i] = n * s_envelopeVolumeMap[(int)(MIN(m_currentValue, N1_0) * 255)] * velocity;
    }
}

#undef N1_0

- (BOOL)playing
{
    return m_playing;
}

@end
