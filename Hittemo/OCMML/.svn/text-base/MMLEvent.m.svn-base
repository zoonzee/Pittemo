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
//  MMLEvent.m
//  OCMML
//
//  Created by hkrn on 09/02/07.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLEvent.h"

@implementation MMLEvent

- (void)setEOT
{
    m_status = kMMLEventEot;
}

- (void)enableNoteWithNumber:(int)number
                    velocity:(int)velocity
{
    m_status = kMMLEventNoteOn;
    u.note.number = number;
    u.note.velocity = velocity;
}

- (void)disableNoteWithNumber:(int)number
                     velocity:(int)velocity
{
    m_status = kMMLEventNoteOff;
    u.note.number = number;
    u.note.velocity = velocity;
}

- (void)setTempo:(int)tempo
{
    m_status = kMMLEventTempo;
    u.tempo = tempo;
}

- (void)setVolume:(int)volume
{
    m_status = kMMLEventVolume;
    u.volume = volume;
}

- (void)setNoteNumber:(int)number
{
    m_status = kMMLEventNote;
    u.noteNumber = number;
}

- (void)setForm:(enum MMLOscillatorType)form
        subform:(enum MMLOscillatorType)subform
{
    m_status = kMMLEventForm;
    u.form.main = form;
    u.form.sub = subform;
}

- (void)setEnvelopeWithAttack:(int)attack
                        decay:(int)decay
                      sustain:(int)sustain
                      release:(int)release
{
    u.envelope.attack = attack;
    u.envelope.decay = decay;
    u.envelope.sustain = sustain;
    u.envelope.release = release;
}


- (void)setEnvelopeForVCOWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release
{
    m_status = kMMLEventEnvelopeForVCO;
    [self setEnvelopeWithAttack:attack
                          decay:decay
                        sustain:sustain
                        release:release];
}

- (void)setEnvelopeForVCFWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release;
{
    m_status = kMMLEventEnvelopeForVCF;
    [self setEnvelopeWithAttack:attack
                          decay:decay
                        sustain:sustain
                        release:release];
}

- (void)setNoiseFrequency:(int)frequency
{
    m_status = kMMLEventNoiseFrequency;
    u.frequency = frequency;
}

- (void)setPWM:(int)pwm
{
    m_status = kMMLEventPWM;
    u.PWM = pwm;
}

- (void)setPan:(int)pan
{
    m_status = kMMLEventPan;
    u.pan = pan;
}

- (void)setFormantVowel:(enum MMLFormantVowelType)vowel
{
    m_status = kMMLEventFormant;
    u.vowel = vowel;
}

- (void)setDetune:(int)detune
{
    m_status = kMMLEventDetune;
    u.detune = detune;
}

- (void)setLFOForm:(enum MMLOscillatorType)form
           subform:(enum MMLOscillatorType)subForm
             depth:(int)depth
             width:(int)width
             delay:(int)delay
              time:(int)aTime
           reverse:(BOOL)reverse
{
    m_status = kMMLEventLFO;
    u.LFO.main = form;
    u.LFO.sub = subForm;
    u.LFO.depth = depth;
    u.LFO.width = width;
    u.LFO.delay = delay;
    u.LFO.time = aTime;
    u.LFO.reverse = reverse;
}

- (void)setLPFSwitch:(enum MMLFilterType)aSwitch
              amount:(int)amount
           frequency:(int)frequency
           resonance:(int)resonance
{
    m_status = kMMLEventLPF;
    u.LPF.swt = aSwitch;
    u.LPF.amt = amount;
    u.LPF.frequency = frequency;
    u.LPF.resonance = resonance;
}

- (void)setClose
{
    m_status = kMMLEventClose;
}

- (void)setVolumeMode:(int)mode
{
    m_status = kMMLEventVolumeMode;
    u.mode = mode;
}

- (void)setInputWithSens:(int)sens
                    pipe:(int)aPipe
{
    m_status = kMMLEventInput;
    u.input.sens = sens;
    u.input.pipe = aPipe;
}

- (void)setOutputWithMode:(enum MMLChannelOutputMode)mode
                     pipe:(int)aPipe
{
    m_status = kMMLEventOutput;
    u.output.mode = mode;
    u.output.pipe = aPipe;
}

- (void)setExpression:(int)expression
{
    u.expression = expression;
}

- (void)setRingWithSens:(int)sens
                   pipe:(int)aPipe
{
    m_status = kMMLEventRingModulate;
    u.ring.sens = sens;
    u.ring.pipe = aPipe;
}

- (void)setSyncWithMode:(enum MMLChannelOutputMode)mode
                   pipe:(int)aPipe
{
    m_status = kMMLEventSync;
    u.sync.mode = mode;
    u.sync.pipe = aPipe;
}

- (void)setDelta:(int)delta
{
    m_delta = delta;
}

- (enum MMLEventType)status
{
    return m_status;
}

- (int)delta
{
    return m_delta;
}

- (int)noteNumber
{
    return u.note.number;
}

- (int)velocity
{
    return u.note.velocity;
}

- (int)tempo
{
    return u.tempo;
}

- (int)volume
{
    return u.volume;
}

- (enum MMLOscillatorType)form
{
    return u.form.main;
}

- (enum MMLOscillatorType)subform
{
    return u.form.sub;
}

- (int)envelopeAttack
{
    return u.envelope.attack;
}

- (int)envelopeDecay
{
    return u.envelope.decay;
}

- (int)envelopeSustain
{
    return u.envelope.sustain;
}

- (int)envelopeRelease
{
    return u.envelope.release;
}

- (int)noiseFrequency
{
    return u.frequency;
}

- (int)PWM
{
    return u.PWM;
}

- (int)pan
{
    return u.pan;
}

- (enum MMLFormantVowelType)vowel
{
    return u.vowel;
}

- (int)detune
{
    return u.detune;
}

- (int)LFODepth
{
    return u.LFO.depth;
}

- (int)LFOWidth
{
    return u.LFO.width;
}

- (enum MMLOscillatorType)LFOForm
{
    return u.LFO.main;
}

- (enum MMLOscillatorType)LFOSubform
{
    return u.LFO.sub;
}

- (int)LFODelay
{
    return u.LFO.delay;
}

- (int)LFOTime
{
    return u.LFO.time;
}

- (BOOL)LFOReverse
{
    return u.LFO.reverse;
}

- (enum MMLFilterType)LPFSwitch
{
    return u.LPF.swt;
}

- (int)LPFAmount
{
    return u.LPF.amt;
}

- (int)LPFFrequency
{
    return u.LPF.frequency;
}

- (int)LPFResonance
{
    return u.LPF.resonance;
}

- (int)volumeMode
{
    return u.mode;
}

- (int)inputSens
{
    return u.input.sens;
}

- (int)inputPipe
{
    return u.input.pipe;
}

- (enum MMLChannelOutputMode)outputMode
{
    return u.output.mode;
}

- (int)outputPipe
{
    return u.output.pipe;
}

- (int)expression
{
    return u.expression;
}

- (int)ringSens
{
    return u.ring.sens;
}

- (int)ringPipe
{
    return u.ring.pipe;
}

- (enum MMLChannelOutputMode)syncMode
{
    return u.sync.mode;
}

- (int)syncPipe
{
    return u.sync.pipe;
}

@end
