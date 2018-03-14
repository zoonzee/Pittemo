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
//  MMLEvent.h
//  OCMML
//
//  Created by hkrn on 09/02/07.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLChannel.h"
#import "MMLFilter.h"
#import "MMLFormant.h"
#import "MMLOscillator.h"

enum MMLEventType {
    kMMLEventEot,            // 0
    kMMLEventNop,            // 1
    kMMLEventNoteOn,         // 2
    kMMLEventNoteOff,        // 3
    kMMLEventTempo,          // 4
    kMMLEventVolume,         // 5
    kMMLEventNote,           // 6
    kMMLEventForm,           // 7
    kMMLEventEnvelopeForVCO, // 8
    kMMLEventNoiseFrequency, // 9
    kMMLEventPWM,            // 10
    kMMLEventPan,            // 11
    kMMLEventFormant,        // 12
    kMMLEventDetune,         // 13
    kMMLEventLFO,            // 14
    kMMLEventLPF,            // 15
    kMMLEventClose,          // 16
    kMMLEventVolumeMode,     // 17
    kMMLEventEnvelopeForVCF, // 18
    kMMLEventInput,          // 19
    kMMLEventOutput,         // 20
    kMMLEventExpression,     // 21
    kMMLEventRingModulate,   // 22
    kMMLEventSync            // 23
};

@interface MMLEvent : NSObject
{
@private
    enum MMLEventType m_status;
    int m_delta;
    union _u {
        struct _note {
            int number;
            int velocity;
        } note;
        int tempo;
        int volume;
        int noteNumber;
        struct _form {
            enum MMLOscillatorType main;
            enum MMLOscillatorType sub;
        } form;
        struct _envelope {
            int attack;
            int decay;
            int sustain;
            int release;
        } envelope;
        int frequency;
        int PWM;
        int pan;
        enum MMLFormantVowelType vowel;
        int detune;
        struct _LFO {
            enum MMLOscillatorType main;
            enum MMLOscillatorType sub;
            int depth;
            int width;
            int delay;
            int time;
            BOOL reverse;
        } LFO;
        struct _LPF {
            enum MMLFilterType swt;
            int amt;
            int frequency;
            int resonance;
        } LPF;
        int mode;
        struct _input {
            int sens;
            int pipe;
        } input;
        struct _output {
            enum MMLChannelOutputMode mode;
            int pipe;
        } output;
        struct _ring {
            int sens;
            int pipe;
        } ring;
        struct _sync {
            enum MMLChannelOutputMode mode;
            int pipe;
        } sync;
        int expression;
    } u;
}

- (void)setEOT;
- (void)enableNoteWithNumber:(int)number
                    velocity:(int)velocity;
- (void)disableNoteWithNumber:(int)number
                     velocity:(int)velocity;
- (void)setTempo:(int)tempo;
- (void)setVolume:(int)volume;
- (void)setNoteNumber:(int)number;
- (void)setForm:(enum MMLOscillatorType)form
        subform:(enum MMLOscillatorType)subform;
- (void)setEnvelopeForVCOWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release;
- (void)setEnvelopeForVCFWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release;
- (void)setNoiseFrequency:(int)frequency;
- (void)setPWM:(int)pwm;
- (void)setPan:(int)pan;
- (void)setFormantVowel:(enum MMLFormantVowelType)vowel;
- (void)setDetune:(int)detune;
- (void)setLFOForm:(enum MMLOscillatorType)form
           subform:(enum MMLOscillatorType)subform
             depth:(int)depth
             width:(int)width
             delay:(int)delay
              time:(int)aTime
           reverse:(BOOL)reverse;
- (void)setLPFSwitch:(enum MMLFilterType)aSwitch
              amount:(int)amount
           frequency:(int)frequency
           resonance:(int)resonance;
- (void)setClose;
- (void)setVolumeMode:(int)mode;
- (void)setInputWithSens:(int)sens
                    pipe:(int)pipe;
- (void)setOutputWithMode:(enum MMLChannelOutputMode)mode
                     pipe:(int)aPipe;
- (void)setDelta:(int)delta;
- (void)setExpression:(int)expression;
- (void)setRingWithSens:(int)sens
                   pipe:(int)pipe;
- (void)setSyncWithMode:(enum MMLChannelOutputMode)mode
                   pipe:(int)aPipe;

@property(nonatomic, readonly) enum MMLEventType status;
@property(nonatomic, readonly) int delta;
@property(nonatomic, readonly) int noteNumber;
@property(nonatomic, readonly) int velocity;
@property(nonatomic, readonly) int tempo;
@property(nonatomic, readonly) int volume;
@property(nonatomic, readonly) enum MMLOscillatorType form;
@property(nonatomic, readonly) enum MMLOscillatorType subform;
@property(nonatomic, readonly) int envelopeAttack;
@property(nonatomic, readonly) int envelopeDecay;
@property(nonatomic, readonly) int envelopeSustain;
@property(nonatomic, readonly) int envelopeRelease;
@property(nonatomic, readonly) int noiseFrequency;
@property(nonatomic, readonly) int PWM;
@property(nonatomic, readonly) int pan;
@property(nonatomic, readonly) enum MMLFormantVowelType vowel;
@property(nonatomic, readonly) int detune;
@property(nonatomic, readonly) int LFODepth;
@property(nonatomic, readonly) int LFOWidth;
@property(nonatomic, readonly) enum MMLOscillatorType LFOForm;
@property(nonatomic, readonly) enum MMLOscillatorType LFOSubform;
@property(nonatomic, readonly) int LFODelay;
@property(nonatomic, readonly) int LFOTime;
@property(nonatomic, readonly) BOOL LFOReverse;
@property(nonatomic, readonly) enum MMLFilterType LPFSwitch;
@property(nonatomic, readonly) int LPFAmount;
@property(nonatomic, readonly) int LPFFrequency;
@property(nonatomic, readonly) int LPFResonance;
@property(nonatomic, readonly) int volumeMode;
@property(nonatomic, readonly) int inputSens;
@property(nonatomic, readonly) int inputPipe;
@property(nonatomic, readonly) enum MMLChannelOutputMode outputMode;
@property(nonatomic, readonly) int outputPipe;
@property(nonatomic, readonly) int expression;
@property(nonatomic, readonly) int ringSens;
@property(nonatomic, readonly) int ringPipe;
@property(nonatomic, readonly) enum MMLChannelOutputMode syncMode;
@property(nonatomic, readonly) int syncPipe;

@end
