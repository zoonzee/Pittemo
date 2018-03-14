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
//  MMLFilter.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLFilter.h"

// to use kSampleRate and kSampleFrequencyBase
#import "Oscillators.h"

@implementation MMLFilter

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self setSwitch:0];
    }
    return self;
}

- (void)reset
{
    t1 = t2 = b0 = b1 = b2 = b3 = b4 = 0;
}

- (void)setSwitch:(enum MMLFilterType)aSwitch
{
    [self reset];
    sw = aSwitch;
}

static inline void UpdateCut(CGFloat *cut)
{
    if (*cut < (1.0 / 127.0))
        *cut = 0;
    CGFloat n = 1;
#if CGFLOAT_IS_DOUBLE
    n -= 0.0001;
#else
    n -= 0.0001f;
#endif
    *cut = MIN(*cut, n);
}

static inline void UpdateCutAndFb(CGFloat *cut, CGFloat *fb, CGFloat resonance)
{
    UpdateCut(cut);
    *fb = resonance + resonance / (1 - *cut);
}

static inline CGFloat GetKeyValue(CGFloat key)
{
    CGFloat n = 0;
#if CGFLOAT_IS_DOUBLE
    n = 2.0 * M_PI;
#else
    n = 2.0f * (CGFloat)M_PI;
#endif
    return key * (n / (kSampleRate * kSampleFrequencyBase));
}

- (void)updateSamplesForHPF1:(CGFloat *)aSamples
                       index:(int)i
                         cut:(CGFloat)cut
                          fb:(CGFloat)fb
{
    CGFloat input = aSamples[i];
    b0 = b0 + cut * (input - b0 + fb * (b0 - b1));
    b1 = b1 + cut * (b0 - b1);
    aSamples[i] = input - b0;
}

- (void)updateSamplesForLPF1:(CGFloat *)aSamples
                       index:(int)i
                         cut:(CGFloat)cut
                          fb:(CGFloat)fb
{
    b0 = b0 + cut * (aSamples[i] - b0 + fb * (b0 - b1));
    aSamples[i] = b1 = b1 + cut * (b0 - b1);
}

- (void)LPF1WithSamples:(CGFloat *)samples
                  start:(int)start
                    end:(int)end
               envelope:(MMLEnvelope *)envelope
              frequency:(CGFloat)frequency
                 amount:(CGFloat)amount
             resonance:(CGFloat)resonance
                    key:(CGFloat)key
{
    CGFloat k = GetKeyValue(key);
    CGFloat fb = 0;
    if (amount > 0.0001 || amount < -0.0001) {
        for (int i = start; i < end; i++) {
            CGFloat cut = [MMLChannel frequencyWithNumber:(int)(frequency + amount * envelope.nextAmplitudeLinear)] * k;
            UpdateCutAndFb(&cut, &fb, resonance);
            [self updateSamplesForLPF1:samples
                                 index:i
                                   cut:cut
                                    fb:fb];
        }
    }
    else {
        CGFloat cut = [MMLChannel frequencyWithNumber:(int)frequency] * k;
        UpdateCutAndFb(&cut, &fb, resonance);
        for (int i = start; i < end; i++) {
            [self updateSamplesForLPF1:samples
                                 index:i
                                   cut:cut
                                    fb:fb];
        }
    }
}

- (void)LPF2WithSamples:(CGFloat *)samples
                  start:(int)start
                    end:(int)end
               envelope:(MMLEnvelope *)envelope
              frequency:(CGFloat)frequency
                 amount:(CGFloat)amount
              resonance:(CGFloat)resonance
                    key:(CGFloat)key
{
    CGFloat k = GetKeyValue(key);
    for (int i = start; i < end; i++) {
        CGFloat cut = [MMLChannel frequencyWithNumber:(int)(frequency + amount * envelope.nextAmplitudeLinear)] * k;
        UpdateCut(&cut);
        CGFloat q = 1 - cut;
        CGFloat p = cut +
#if CGFLOAT_IS_DOUBLE
        0.8
#else
        0.8f
#endif
        * cut * q;
        CGFloat f = p + p - 1;
#if CGFLOAT_IS_DOUBLE
        q = resonance * (1 + 0.5 * q * (1 - q + 5.6 * q * q));
#else
        q = resonance * (1 + 0.5f * q * (1 - q + 5.6f * q * q));
#endif
        CGFloat input = samples[i];
        input -= q * b4;
        t1 = b1;
        b1 = (input + b0) * p - b1 * f;
        t2 = b2;
        b2 = (b1 + t1) * p - b2 * f;
        t1 = b3;
        b3 = (b2 + t2) * p - b3 * f;
        b4 = (b3 + t1) * p - b4 * f;
        b4 = b4 - b4 * b4 * b4 *
#if CGFLOAT_IS_DOUBLE
        0.166667;
#else
        0.166667f;
#endif
        b0 = input;
        samples[i] = b4;
    }
}

- (void)HPF1WithSamples:(CGFloat *)samples
                  start:(int)start
                    end:(int)end
               envelope:(MMLEnvelope *)envelope
              frequency:(CGFloat)frequency
                 amount:(CGFloat)amount
              resonance:(CGFloat)resonance
                    key:(CGFloat)key
{
    CGFloat k = GetKeyValue(key);
    CGFloat fb = 0;
    if (amount > 0.0001 || amount < -0.0001) {
        for (int i = start; i < end; i++) {
            CGFloat cut = [MMLChannel frequencyWithNumber:(int)(frequency + amount * envelope.nextAmplitudeLinear)] * k;
            UpdateCutAndFb(&cut, &fb, resonance);
            [self updateSamplesForHPF1:samples
                                 index:i
                                   cut:cut
                                    fb:fb];
        }
    }
    else {
        CGFloat cut = [MMLChannel frequencyWithNumber:(int)frequency] * k;
        UpdateCutAndFb(&cut, &fb, resonance);
        for (int i = start; i < end; i++) {
            [self updateSamplesForHPF1:samples
                                 index:i
                                   cut:cut
                                    fb:fb];
        }
    }
}

- (void)HPF2WithSamples:(CGFloat *)samples
                  start:(int)start
                    end:(int)end
               envelope:(MMLEnvelope *)envelope
              frequency:(CGFloat)frequency
                 amount:(CGFloat)amount
              resonance:(CGFloat)resonance
                    key:(CGFloat)key
{
    CGFloat k = GetKeyValue(key);
    for (int i = start; i < end; i++) {
        CGFloat cut = [MMLChannel frequencyWithNumber:(int)(frequency + amount * envelope.nextAmplitudeLinear)] * k;
        UpdateCut(&cut);
        CGFloat q = 1 - cut;
        CGFloat p = cut +
#if CGFLOAT_IS_DOUBLE
        0.8
#else
        0.8f
#endif
        * cut * q;
        CGFloat f = p + p - 1;
#if CGFLOAT_IS_DOUBLE
        q = resonance * (1 + 0.5 * q * (1 - q + 5.6 * q * q));
#else
        q = resonance * (1 + 0.5f * q * (1 - q + 5.6f * q * q));
#endif
        CGFloat input = samples[i];
        input -= q * b4;
        t1 = b1;
        b1 = (input + b0) * p - b1 * f;
        t2 = b2;
        b2 = (b1 + t1) * p - b2 * f;
        t1 = b3;
        b3 = (b2 + t2) * p - b3 * f;
        b4 = (b3 + t1) * p - b4 * f;
        b4 = b4 - b4 * b4 * b4 *
#if CGFLOAT_IS_DOUBLE
        0.166667;
#else
        0.166667f;
#endif
        b0 = input;
        samples[i] = input - b4;
    }
}

- (void)runWithSamples:(CGFloat *)samples
                 start:(int)start
                   end:(int)end
              envelope:(MMLEnvelope *)envelope
             frequency:(CGFloat)frequeycy
                amount:(CGFloat)amount
             resonance:(CGFloat)resonance
                   key:(CGFloat)key
{
    switch (sw) {
        case kMMLFilterHPFFast:
            [self HPF2WithSamples:samples
                            start:start
                              end:end
                         envelope:envelope
                        frequency:frequeycy
                           amount:amount
                        resonance:resonance
                              key:key];
            break;
        case kMMLFilterHPFQuality:
            [self HPF1WithSamples:samples
                            start:start
                              end:end
                         envelope:envelope
                        frequency:frequeycy
                           amount:amount
                        resonance:resonance
                              key:key];
            break;
        case kMMLFilterLPFQuality:
            [self LPF1WithSamples:samples
                            start:start
                              end:end
                         envelope:envelope
                        frequency:frequeycy
                           amount:amount
                        resonance:resonance
                              key:key];
            break;
        case kMMLFilterLPFFast:
            [self LPF2WithSamples:samples
                            start:start
                              end:end
                         envelope:envelope
                        frequency:frequeycy
                           amount:amount
                        resonance:resonance
                              key:key];
            break;
        case kMMLFilterNone:
        default:
            break;
    }
}

@end
