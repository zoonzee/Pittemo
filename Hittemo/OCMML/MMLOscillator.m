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
//  Oscillator.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Oscillator/Oscillators.h"
#import "MMLOscillator.h"

@implementation MMLOscillator

@synthesize form;

- (id)init
{
    self = [super init];
    if (self != nil) {
        m_oscillators[kMMLOscillatorSine] = [[Sine alloc] init];
        m_oscillators[kMMLOscillatorSaw] = [[Saw alloc] init];
        m_oscillators[kMMLOscillatorTriangle] = [[Triangle alloc] init];
        m_oscillators[kMMLOscillatorPulse] = [[Pulse alloc] init];
        m_oscillators[kMMLOscillatorNoise] = [[Noise alloc] init];
        m_oscillators[kMMLOscillatorFCPulse] = [[Pulse alloc] init];
        m_oscillators[kMMLOscillatorFCTriangle] = [[FCTriangle alloc] init];
        m_oscillators[kMMLOscillatorFCNoise] = [[FCNoise alloc] init];
        m_oscillators[kMMLOscillatorFCShortNoise] = nil;
        m_oscillators[kMMLOscillatorFCDPCM] = [[FCDPCM alloc] init];
        m_oscillators[kMMLOscillatorGBWave] = [[GBWave alloc] init];
        m_oscillators[kMMLOscillatorGBLongNoise] = [[GBLongNoise alloc] init];
        m_oscillators[kMMLOscillatorGBShortNoise] = [[GBShortNoise alloc] init];
        self.form = kMMLOscillatorPulse;
    }
    return self;
}

- (void)dealloc
{
    [m_oscillators[kMMLOscillatorSine] release];
    [m_oscillators[kMMLOscillatorSaw] release];
    [m_oscillators[kMMLOscillatorTriangle] release];
    [m_oscillators[kMMLOscillatorPulse] release];
    [m_oscillators[kMMLOscillatorNoise] release];
    [m_oscillators[kMMLOscillatorFCPulse] release];
    [m_oscillators[kMMLOscillatorFCTriangle] release];
    [m_oscillators[kMMLOscillatorFCNoise] release];
    [m_oscillators[kMMLOscillatorFCDPCM] release];
    [m_oscillators[kMMLOscillatorGBWave] release];
    [m_oscillators[kMMLOscillatorGBLongNoise] release];
    [m_oscillators[kMMLOscillatorGBShortNoise] release];
    [super dealloc];
}

- (enum MMLOscillatorType)form
{
    return m_form;
}

- (void)setForm:(enum MMLOscillatorType)aForm
{
    Noise *noise;
    FCNoise *fcNoise;
    if (aForm >= kMMLOscillatorMax) {
        aForm = kMMLOscillatorMax - 1;
    }
    m_form = aForm;
    switch (aForm) {
        case kMMLOscillatorNoise:
            noise = (Noise *)m_oscillators[kMMLOscillatorNoise];
            [noise restoreFrequency];
            break;
        case kMMLOscillatorFCNoise:
            fcNoise = (FCNoise *)[self modulatorFromForm:kMMLOscillatorFCNoise];
            [fcNoise setLongMode];
            break;
        case kMMLOscillatorFCShortNoise:
            fcNoise = (FCNoise *)[self modulatorFromForm:kMMLOscillatorFCShortNoise];
            [fcNoise setShortMode];
            break;
        default:
            break;
    }
}

- (Modulator *)modulatorFromForm:(enum MMLOscillatorType)aForm
{
    aForm = MIN(MAX(aForm, 0), kMMLOscillatorMax - 1);
    return aForm != kMMLOscillatorFCShortNoise ? m_oscillators[aForm] : m_oscillators[kMMLOscillatorFCShortNoise];
}

- (Modulator *)currentModulator
{
    return [self modulatorFromForm:m_form];
}

- (void)asLFO
{
    if (m_oscillators[kMMLOscillatorNoise]) {
        Noise *noise = (Noise *)m_oscillators[kMMLOscillatorNoise];
        noise.shouldResetPhase = NO;
    }
}

@end
