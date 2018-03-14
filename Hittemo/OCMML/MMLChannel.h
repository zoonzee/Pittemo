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
//  MMLChannel.h
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLEnvelope.h"
#import "MMLFilter.h"
#import "MMLFormant.h"
#import "MMLOscillator.h"

@class MMLFilter, Modulator;

enum MMLChannelOutputMode {
    kMMLChannelOutputDefault = 0,
    kMMLChannelOutputOverwrite = 1,
    kMMLChannelOutputAdd = 2
};

@interface MMLChannel : NSObject
{
@private
    int m_noteNo;
    int m_detune;
    int m_frequencyNo;
    MMLEnvelope *m_envelope4VCO;
    MMLEnvelope *m_envelope4VCF;
    MMLOscillator *m_set1;
    Modulator *m_mod1;
    MMLOscillator *m_set2;
    Modulator *m_mod2;
    BOOL m_osc2connect;
    CGFloat m_osc2sign;
    MMLFilter *m_filter;
    int m_filterConnect;
    MMLFormant *m_formant;
    int m_volumeMode;
    CGFloat m_velocity;
    CGFloat m_expression;
    CGFloat m_ampLevel;
    CGFloat m_panLeft;
    CGFloat m_panRight;
    int m_onCounter;
    int m_lfoDelay;
    CGFloat m_lfoDepth;
    int m_lfoEnd;
    CGFloat m_lpfAmount;
    CGFloat m_lpfFrequency;
    CGFloat m_lpfResonance;
    CGFloat m_inSens;
    int m_inPipe;
    enum MMLChannelOutputMode m_outMode;
    int m_outPipe;
    CGFloat m_ringSens;
    int m_ringPipe;
    int m_syncMode;
    int m_syncPipe;
}

- (void)setNoteNumber:(int)number;
- (void)setDetune:(int)detune;
- (void)enableNoteAtNumber:(int)number
                  velocity:(int)velocity;
- (void)setFrequency:(int)number;
- (void)disableNote;
- (void)close;
- (void)setNoiseFrequency:(CGFloat)frequency;
- (void)setForm:(enum MMLOscillatorType)form
        subform:(enum MMLOscillatorType)subForm;
- (void)setEnvelopeForVCOWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release;
- (void)setEnvelopeForVCFWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release;
- (void)setPWM:(int)pwm;
- (void)setPan:(int)pan;
- (void)setFormantVowel:(enum MMLFormantVowelType)vowel;
- (void)setLFOForm:(enum MMLOscillatorType)form
           subform:(enum MMLOscillatorType)subform
             depth:(int)depth
         frequency:(CGFloat)frequency
             delay:(int)delay
              time:(int)time
           reverse:(BOOL)reverse;
- (void)setLPFSwitch:(enum MMLFilterType)aSwitch
              amount:(int)amount
           frequency:(int)frequency
          resonance:(int)resonance;
- (void)setVolumeMode:(int)mode;
- (void)setInput:(int)inSens
            pipe:(int)inPipe;
- (void)setOutput:(enum MMLChannelOutputMode)output
             pipe:(int)outPipe;
- (void)setVelocity:(int)velocity;
- (void)setExpression:(int)expression;
- (void)setRingSens:(int)sens
               pipe:(int)aPipe;
- (void)setSyncMode:(enum MMLChannelOutputMode)mode
               pipe:(int)aPipe;
- (void)getSamples:(CGFloat *)samples
             start:(int)start
             delta:(int)delta
               max:(int)max;

+ (void)initializeWithSamples:(int)numberOfSamples;
+ (void)releaseChannel;
+ (void)createPipes:(int)number;
+ (void)createSyncSources:(int)number;
+ (CGFloat)frequencyWithNumber:(int)number;

@end
