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
//  MMLTrack.h
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLChannel.h"
#import "MMLEvent.h"
#import "MMLFormant.h"

#define kTempoTrack 0
#define kFirstTrack 1
#define kDefaultBPM 120

@interface MMLTrack : NSObject
{
@private
    MMLChannel *m_channel;
    NSMutableArray *m_events;
    NSUInteger m_index;
    NSUInteger m_duration;
    BOOL m_isEnd;
    int m_volume;
    int m_delta;
    unsigned int m_globalTick;
    CGFloat m_bpm;
    CGFloat m_spt;
    CGFloat m_needle;
    CGFloat m_gate;
    CGFloat m_gate2;
    CGFloat m_lfoWidth;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end;
- (void)seekWithDelta:(int)delta;
- (void)recordDeltaWithEvent:(MMLEvent *)event;
- (void)recordNoteAtNumber:(int)number
                    length:(int)length
                  velocity:(int)velocity
                     keyOn:(BOOL)keyOn
                    keyOff:(BOOL)keyOff;
- (void)recordRestWithLength:(int)length;
- (void)recordRestWithTimeSpan:(unsigned int)msec;
- (void)recordVolume:(int)volume;
- (void)recordTempo:(int)tempo
         globalTick:(unsigned int)globalTick;
- (void)recordEOT;
- (void)recordGate:(CGFloat)gate;
- (void)recordGate2:(int)gate2;
- (void)recordForm:(enum MMLOscillatorType)form
           subform:(enum MMLOscillatorType)subform;
- (void)recordEnvelopeWithAttack:(int)attack
                           decay:(int)decay
                         sustain:(int)sustain
                         release:(int)release
                           isVCO:(BOOL)isVCO;
- (void)recordNoiseFrequency:(int)frequency;
- (void)recordPWM:(int)pwm;
- (void)recordPan:(int)pan;
- (void)recordFormantVowel:(enum MMLFormantVowelType)vowel;
- (void)recordDetune:(int)detune;
- (void)recordLFOWithDepth:(int)depth
                     width:(int)width
                      form:(enum MMLOscillatorType)form
                   subForm:(enum MMLOscillatorType)subform
                     delay:(int)delay
                      time:(int)time
               reverse:(BOOL)reverse;
- (void)recordLFPWithSwitch:(enum MMLFilterType)aSwitch
                     amount:(int)amount
                  frequency:(int)frequency
                  resonance:(int)resonance;
- (void)recordVolumeMode:(int)mode;
- (void)recordInputWithSens:(int)sens
                       pipe:(int)inPipe;
- (void)recordOutputWithMode:(enum MMLChannelOutputMode)mode
                        pipe:(int)outPipe;
- (void)recordExpression:(int)expression;
- (void)recordRingWithSens:(int)sens
                      pipe:(int)aPipe;
- (void)recordSyncWithMode:(enum MMLChannelOutputMode)mode
                      pipe:(int)aPipe;
- (void)recordClose;
- (void)seekHead;
- (void)conductTracks:(NSMutableArray *)tracks;

@property(readonly) BOOL isEnd;
@property(readonly) unsigned int globalTick;
@property(readonly) NSUInteger duration;
@property(readonly) NSUInteger eventCount;

@end
