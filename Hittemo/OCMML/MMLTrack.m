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
//  MMLTrack.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Oscillators.h"
#import "MMLTrack.h"
#import "MMLTrack+Private.h"

@implementation MMLTrack

@synthesize isEnd, globalTick, duration;

- (BOOL)isEnd
{
    return m_isEnd;
}

- (unsigned int)globalTick
{
    return m_globalTick;
}

- (NSUInteger)duration
{
    return m_duration;
}

static inline MMLEvent *CreateEvent(id s) {
    MMLEvent *event = [[MMLEvent alloc] init];
    [s recordDeltaWithEvent:event];
    return event;
}

static inline void AddEvent(MMLEvent *aEvent, NSMutableArray **aEvents) {
    [*aEvents addObject:aEvent];
    [aEvent release];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        m_isEnd = NO;
        m_channel = [[MMLChannel alloc] init];
        m_events = [[NSMutableArray alloc] initWithCapacity:32];
        m_index = 0;
        m_delta = 0;
        m_globalTick = 0;
        m_lfoWidth = 0;
        m_needle = 0;
        m_volume = 100;
        m_duration = 0;
        CGFloat n = 0;
#if CGFLOAT_IS_DOUBLE
        n = 15.0 / 16.0;
#else
        n = 15.0f / 16.0f;
#endif
        [self playWithTempo:kDefaultBPM];
        [self recordGate:n];
        [self recordGate2:0];
    }
    return self;
}

- (void)dealloc
{
    [m_channel release];
    [m_events release];
    [super dealloc];
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
               end:(int)end
{
    if (m_isEnd) {
        return;
    }
    //NSLog(@"[updatingSampleData] %d:%d", start, end);
    for (int i = start; i < end;) {
        BOOL exec = NO;
        CGFloat delta = 0;
        NSUInteger eventsLength = [m_events count];
        do {
            exec = NO;
            if (m_index < eventsLength) {
                MMLEvent *event = [m_events objectAtIndex:m_index];
                delta = event.delta * m_spt;
                if (m_needle >= delta) {
                    exec = YES;
                    switch (event.status) {
                        case kMMLEventNoteOn:
                            [m_channel enableNoteAtNumber:event.noteNumber
                                                 velocity:event.velocity];
                            break;
                        case kMMLEventNoteOff:
                            [m_channel disableNote];
                            break;
                        case kMMLEventNote:
                            [m_channel setNoteNumber:event.noteNumber];
                            break;
                        case kMMLEventVolume:
                            break;
                        case kMMLEventTempo:
                            [self playWithTempo:event.tempo];
                            break;
                        case kMMLEventForm:
                            [m_channel setForm:event.form
                                       subform:event.subform];
                            break;
                        case kMMLEventEnvelopeForVCO:
                            [m_channel setEnvelopeForVCOWithAttack:event.envelopeAttack
                                                             decay:event.envelopeDecay
                                                           sustain:event.envelopeSustain
                                                           release:event.envelopeRelease];
                            break;
                        case kMMLEventEnvelopeForVCF:
                            [m_channel setEnvelopeForVCFWithAttack:event.envelopeAttack
                                                             decay:event.envelopeDecay
                                                           sustain:event.envelopeSustain
                                                           release:event.envelopeRelease];
                            break;
                        case kMMLEventNoiseFrequency:
                            [m_channel setNoiseFrequency:event.noiseFrequency];
                            break;
                        case kMMLEventPWM:
                            [m_channel setPWM:event.PWM];
                            break;
                        case kMMLEventPan:
                            [m_channel setPan:event.pan];
                            break;
                        case kMMLEventFormant:
                            [m_channel setFormantVowel:event.vowel];
                            break;
                        case kMMLEventDetune:
                            [m_channel setDetune:event.detune];
                            break;
                        case kMMLEventLFO:
                            m_lfoWidth = event.LFOWidth * m_spt;
                            [m_channel setLFOForm:event.LFOForm
                                          subform:event.LFOSubform
                                            depth:event.LFODepth
                                        frequency:kSampleRate / m_lfoWidth
                                            delay:event.LFODelay
                                             time:event.LFOTime
                                          reverse:event.LFOReverse];
                            break;
                        case kMMLEventLPF:
                            [m_channel setLPFSwitch:event.LPFSwitch
                                             amount:event.LPFAmount
                                          frequency:event.LPFFrequency
                                          resonance:event.LPFResonance];
                            break;
                        case kMMLEventVolumeMode:
                            [m_channel setVolumeMode:event.volumeMode];
                            break;
                        case kMMLEventInput:
                            [m_channel setInput:event.inputSens
                                           pipe:event.inputPipe];
                            break;
                        case kMMLEventOutput:
                            [m_channel setOutput:event.outputMode
                                            pipe:event.outputPipe];
                            break;
                        case kMMLEventExpression:
                            [m_channel setExpression:event.expression];
                            break;
                        case kMMLEventRingModulate:
                            [m_channel setRingSens:event.ringSens
                                              pipe:event.ringPipe];
                            break;
                        case kMMLEventSync:
                            [m_channel setSyncMode:event.syncMode
                                              pipe:event.syncPipe];
                            break;
                        case kMMLEventClose:
                            [m_channel close];
                            break;
                        case kMMLEventEot:
                            m_isEnd = YES;
                            break;
                        case kMMLEventNop:
                        default:
                            break;
                    }
                    m_needle -= delta;
                    m_index++;
                }
            }
        } while (exec);
        int di = 0;
        if (m_index < eventsLength) {
            MMLEvent *event = [m_events objectAtIndex:m_index];
            delta = event.delta * m_spt;
            di = (int)ceil(delta - m_needle);
            if (i + di >= end) {
                di = end - i;
            }
            m_needle += di;
            [m_channel getSamples:samples
                            start:i
                            delta:di
                              max:end];
            i += di;
        }
        else {
            break;
        }
    }
}

- (void)seekWithDelta:(int)delta
{
    m_delta += delta;
    m_globalTick += delta;
}

- (void)recordDeltaWithEvent:(MMLEvent *)event
{
    [event setDelta:m_delta];
    m_delta = 0;
}

- (void)recordNoteAtNumber:(int)number
                    length:(int)length
                  velocity:(int)velocity
                     keyOn:(BOOL)keyOn
                    keyOff:(BOOL)keyOff
{
    MMLEvent *event0 = [[MMLEvent alloc] init];
    if (keyOn) {
        [event0 enableNoteWithNumber:number
                            velocity:velocity];
    }
    else {
        [event0 setNoteNumber:number];
    }
    [self recordDeltaWithEvent:event0];
    AddEvent(event0, &m_events);
    MMLEvent *event1 = [[MMLEvent alloc] init];
    if (keyOff) {
        int gate = MAX((int)(length * m_gate - m_gate2), 0);
        [self seekWithDelta:gate];
        [event1 disableNoteWithNumber:number
                             velocity:velocity];
        [self recordDeltaWithEvent:event1];
        AddEvent(event1, &m_events);
        [self seekWithDelta:length - gate];
    }
    else {
        [self seekWithDelta:length];
        [event1 release];
    }
}

- (void)recordRestWithLength:(int)length
{
    [self seekWithDelta:length];
}

- (void)recordRestWithTimeSpan:(unsigned int)msec
{
    int length = msec * kSampleRate / (int)(m_spt * 1000);
    [self seekWithDelta:length];
}

- (void)recordVolume:(int)volume
{
    MMLEvent *event = CreateEvent(self);
    [event setVolume:volume];
    AddEvent(event, &m_events);
}

- (void)recordGlobalTick:(unsigned int)gTick
                   event:(MMLEvent *)aEvent
{
    NSInteger n = [m_events count];
    unsigned int preGlobalTick = 0;
    for (NSInteger i = 0; i < n; i++) {
        MMLEvent *event = [m_events objectAtIndex:i];
        unsigned int nextTick = preGlobalTick + event.delta;
        //NSLog(@"%d:%d:%d:%d", i, n, nextTick, aGlobalTick);
        if (nextTick >= gTick) {
            [event setDelta:nextTick - gTick];
            [aEvent setDelta:gTick - preGlobalTick];
            [m_events insertObject:aEvent
                           atIndex:i];
            return;
        }
        preGlobalTick = nextTick;
    }
    [aEvent setDelta:gTick - preGlobalTick];
    [m_events addObject:aEvent];
}

- (void)recordTempo:(int)aTempo
         globalTick:(unsigned int)aGlobalTick
{
    MMLEvent *event = CreateEvent(self);
    [event setTempo:aTempo];
    [self recordGlobalTick:aGlobalTick event:event];
    [event release];
}

- (void)recordEOT
{
    MMLEvent *event = CreateEvent(self);
    [event setEOT];
    AddEvent(event, &m_events);
}

- (void)recordGate:(CGFloat)gate
{
    m_gate = gate;
}

- (void)recordGate2:(int)gate2
{
    m_gate2 = MAX(gate2, 0);
}

- (void)recordForm:(enum MMLOscillatorType)form
           subform:(enum MMLOscillatorType)subForm
{
    MMLEvent *event = CreateEvent(self);
    [event setForm:form subform:subForm];
    AddEvent(event, &m_events);
}

- (void)recordEnvelopeWithAttack:(int)attack
                           decay:(int)decay
                         sustain:(int)sustain
                         release:(int)release
                           isVCO:(BOOL)isVCO
{
    MMLEvent *event = CreateEvent(self);
    if (isVCO) {
        [event setEnvelopeForVCOWithAttack:attack
                                     decay:decay
                                   sustain:sustain
                                   release:release];
    }
    else {
        [event setEnvelopeForVCFWithAttack:attack
                                     decay:decay
                                   sustain:sustain
                                   release:release];
    }
    AddEvent(event, &m_events);
}

- (void)recordNoiseFrequency:(int)aFrequency
{
    MMLEvent *event = CreateEvent(self);
    [event setNoiseFrequency:aFrequency];
    AddEvent(event, &m_events);
}

- (void)recordPWM:(int)pwm
{
    MMLEvent *event = CreateEvent(self);
    [event setPWM:pwm];
    AddEvent(event, &m_events);
}

- (void)recordPan:(int)pan
{
    MMLEvent *event = CreateEvent(self);
    [event setPan:pan];
    AddEvent(event, &m_events);
}

- (void)recordFormantVowel:(enum MMLFormantVowelType)vowel
{
    MMLEvent *event = CreateEvent(self);
    [event setFormantVowel:vowel];
    AddEvent(event, &m_events);
}

- (void)recordDetune:(int)detune
{
    MMLEvent *event = CreateEvent(self);
    [event setDetune:detune];
    AddEvent(event, &m_events);
}

- (void)recordLFOWithDepth:(int)depth
                     width:(int)width
                      form:(enum MMLOscillatorType)form
                   subForm:(enum MMLOscillatorType)subForm
                     delay:(int)delay
                      time:(int)aTime
                   reverse:(BOOL)reverse
{
    MMLEvent *event = CreateEvent(self);
    [event setLFOForm:form
              subform:subForm
                depth:depth
                width:width
                delay:delay
                 time:aTime
              reverse:reverse];
    AddEvent(event, &m_events);
}

- (void)recordLFPWithSwitch:(enum MMLFilterType)aSwitch
                     amount:(int)amount
                  frequency:(int)frequency
                  resonance:(int)resonance
{
    MMLEvent *event = CreateEvent(self);
    [event setLPFSwitch:aSwitch
                 amount:amount
              frequency:frequency
              resonance:resonance];
    AddEvent(event, &m_events);
}

- (void)recordVolumeMode:(int)mode
{
    MMLEvent *event = CreateEvent(self);
    [event setVolumeMode:mode];
    AddEvent(event, &m_events);
}

- (void)recordInputWithSens:(int)sens
                       pipe:(int)inPipe
{
    MMLEvent *event = CreateEvent(self);
    [event setInputWithSens:sens
                       pipe:inPipe];
    AddEvent(event, &m_events);
}

- (void)recordOutputWithMode:(enum MMLChannelOutputMode)mode
                        pipe:(int)outPipe
{
    MMLEvent *event = CreateEvent(self);
    [event setOutputWithMode:mode
                        pipe:outPipe];
    AddEvent(event, &m_events);
}

- (void)recordExpression:(int)expression
{
    MMLEvent *event = CreateEvent(self);
    [event setExpression:expression];
    AddEvent(event, &m_events);
}

- (void)recordRingWithSens:(int)sens
                      pipe:(int)aPipe
{
    MMLEvent *event = CreateEvent(self);
    [event setRingWithSens:sens
                      pipe:aPipe];
    AddEvent(event, &m_events);
}

- (void)recordSyncWithMode:(enum MMLChannelOutputMode)mode
                      pipe:(int)aPipe
{
    MMLEvent *event = CreateEvent(self);
    [event setSyncWithMode:mode
                      pipe:aPipe];
    AddEvent(event, &m_events);
}

- (void)recordClose
{
    MMLEvent *event = CreateEvent(self);
    [event setClose];
    AddEvent(event, &m_events);
}

- (void)seekHead
{
    m_globalTick = 0;
}

- (CGFloat)calucateSPT:(CGFloat)aBPM
{
#if CGFLOAT_IS_DOUBLE
    return kSampleRate / (aBPM * 96.0 / 60.0);
#else
    return kSampleRate / (aBPM * 96.0f / 60.0f);
#endif
}

- (void)conductTracks:(NSMutableArray *)tracks
{
    int ni = (int)[m_events count];
    int nj = (int)[tracks count];
    NSUInteger globalSample = 0;
    unsigned int gTick = 0;
    CGFloat spt = [self calucateSPT:kDefaultBPM];
    for (int i = 0; i < ni; i++) {
        MMLEvent *event = [m_events objectAtIndex:i];
        unsigned int delta = event.delta;
        gTick += delta;
        globalSample += (unsigned int)(delta * spt);
        switch (event.status) {
            case kMMLEventTempo:
                for (int j = kFirstTrack; j < nj; j++) {
                    MMLTrack *track = [tracks objectAtIndex:j];
                    //NSLog(@"%d", event.tempo);
                    int tempo = event.tempo;
                    [track recordTempo:tempo
                            globalTick:gTick];
                    spt = [self calucateSPT:tempo];
                }
                break;
            default:
                break;
        }
    }
    int maxGlobalTick = 0;
    for (int j = kFirstTrack; j < nj; j++) {
        MMLTrack *track = [tracks objectAtIndex:j];
        int trackGlobalTick = track.globalTick;
        if (maxGlobalTick < trackGlobalTick) {
            maxGlobalTick = trackGlobalTick;
        }
    }
    MMLEvent *event = [[MMLEvent alloc] init];
    [event setClose];
    [self recordGlobalTick:maxGlobalTick
                     event:event];
    [event release];
    globalSample += (unsigned int)((maxGlobalTick - gTick) * spt);
    [self recordRestWithTimeSpan:3000];
    [self recordEOT];
    globalSample += 3 * kSampleRate;
    m_duration = (NSUInteger)(globalSample * (1000.0 / kSampleRate));
}

- (void)playWithTempo:(CGFloat)bpm
{
    m_bpm = bpm;
    m_spt = [self calucateSPT:bpm];
}

- (NSUInteger)eventCount
{
    return [m_events count];
}

- (NSArray *)dumpTrackEvents
{
    NSMutableArray *r = [NSMutableArray array];
    NSString *statusKey = @"status";
    for (MMLEvent *event in m_events) {
        //CGFloat width;
        int sign;
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        switch (event.status) {
            case kMMLEventNoteOn:
                [e setObject:[NSNumber numberWithInt:event.noteNumber]
                      forKey:@"index"];
                [e setObject:[NSNumber numberWithInt:event.velocity]
                      forKey:@"velocity"];
                [e setObject:@"NoteOn"
                      forKey:statusKey];
                break;
            case kMMLEventNoteOff:
                [e setObject:@"NoteOff"
                      forKey:statusKey];
                break;
            case kMMLEventNote:
                [e setObject:[NSNumber numberWithInt:event.noteNumber]
                      forKey:@"index"];
                [e setObject:@"Note"
                      forKey:statusKey];
                break;
            case kMMLEventVolume:
                [e setObject:@"Volume"
                      forKey:statusKey];
                break;
            case kMMLEventTempo:
                [e setObject:[NSNumber numberWithInt:event.tempo]
                      forKey:@"bpm"];
                [e setObject:@"Tempo"
                      forKey:statusKey];
                break;
            case kMMLEventForm:
                [e setObject:[NSNumber numberWithInt:event.form]
                      forKey:@"form"];
                [e setObject:[NSNumber numberWithInt:event.subform]
                      forKey:@"subform"];
                [e setObject:@"Form"
                      forKey:statusKey];
                break;
            case kMMLEventEnvelopeForVCO:
                [e setObject:[NSNumber numberWithInt:event.envelopeAttack]
                      forKey:@"attack"];
                [e setObject:[NSNumber numberWithInt:event.envelopeDecay]
                      forKey:@"decay"];
                [e setObject:@"VCO"
                      forKey:statusKey];
                [r addObject:e];
                e = [NSMutableDictionary dictionary];
                [e setObject:[NSNumber numberWithInt:event.envelopeSustain]
                      forKey:@"sustain"];
                [e setObject:[NSNumber numberWithInt:event.envelopeRelease]
                      forKey:@"release"];
                [e setObject:@"VCO"
                      forKey:statusKey];
                break;
            case kMMLEventEnvelopeForVCF:
                [e setObject:[NSNumber numberWithInt:event.envelopeAttack]
                      forKey:@"attack"];
                [e setObject:[NSNumber numberWithInt:event.envelopeDecay]
                      forKey:@"decay"];
                [e setObject:@"VCF"
                      forKey:statusKey];
                [r addObject:e];
                e = [NSMutableDictionary dictionary];
                [e setObject:[NSNumber numberWithInt:event.envelopeSustain]
                      forKey:@"sustain"];
                [e setObject:[NSNumber numberWithInt:event.envelopeRelease]
                      forKey:@"release"];
                [e setObject:@"VCF"
                      forKey:statusKey];
                break;
            case kMMLEventNoiseFrequency:
                [e setObject:[NSNumber numberWithInt:event.noiseFrequency]
                      forKey:@"frequency"];
                [e setObject:@"NoiseFrequency"
                      forKey:statusKey];
                break;
            case kMMLEventPWM:
                [e setObject:[NSNumber numberWithInt:event.PWM]
                      forKey:@"pwm"];
                [e setObject:@"PWM"
                      forKey:statusKey];
                break;
            case kMMLEventPan:
                [e setObject:[NSNumber numberWithInt:event.pan]
                      forKey:@"pan"];
                [e setObject:@"Pan"
                      forKey:statusKey];
                break;
            case kMMLEventFormant:
                [e setObject:[NSNumber numberWithInt:event.vowel]
                      forKey:@"formant"];
                [e setObject:@"Vowel"
                      forKey:statusKey];
                break;
            case kMMLEventDetune:
                [m_channel setDetune:event.detune];
                [e setObject:[NSNumber numberWithInt:event.detune]
                      forKey:@"detune"];
                [e setObject:@"Detune"
                      forKey:statusKey];
                break;
            case kMMLEventLFO:
                //width = event.LFOWidth * m_spt;
                sign = event.LFOReverse ? -1 : 1;
                [e setObject:[NSNumber numberWithInt:event.LFOForm * sign]
                      forKey:@"form"];
                [e setObject:[NSNumber numberWithInt:event.LFOSubform]
                      forKey:@"subform"];
                [e setObject:@"LFO"
                      forKey:statusKey];
                [r addObject:e];
                e = [NSMutableDictionary dictionary];
                [e setObject:[NSNumber numberWithInt:event.LFODepth]
                      forKey:@"depth"];
                //[e setObject:[NSNumber numberWithDouble:kSampleRate / event.LFOWidth]
                //      forKey:@"width"];
                [e setObject:@"LFO"
                      forKey:statusKey];
                [r addObject:e];
                e = [NSMutableDictionary dictionary];
                [e setObject:[NSNumber numberWithDouble:event.LFODelay * m_spt]
                      forKey:@"delay"];
                //[e setObject:[NSNumber numberWithDouble:event.LFOTime * event.LFOWidth]
                //      forKey:@"time"];
                [e setObject:@"LFO"
                      forKey:statusKey];
                break;
            case kMMLEventLPF:
                [e setObject:[NSNumber numberWithInt:event.LPFSwitch]
                      forKey:@"switch"];
                [e setObject:[NSNumber numberWithInt:event.LPFAmount]
                      forKey:@"amount"];
                [e setObject:@"LPF"
                      forKey:statusKey];
                [r addObject:e];
                e = [NSMutableDictionary dictionary];
                [e setObject:[NSNumber numberWithInt:event.LPFFrequency]
                      forKey:@"frequency"];
                [e setObject:[NSNumber numberWithInt:event.LPFResonance]
                      forKey:@"resonance"];
                [e setObject:@"LPF"
                      forKey:statusKey];
                break;
            case kMMLEventVolumeMode:
                [e setObject:[NSNumber numberWithInt:event.volumeMode]
                      forKey:@"volumeMode"];
                [e setObject:@"VolumeMode"
                      forKey:statusKey];
                break;
            case kMMLEventInput:
                [e setObject:[NSNumber numberWithInt:event.inputSens]
                      forKey:@"sens"];
                [e setObject:[NSNumber numberWithInt:event.inputPipe]
                      forKey:@"pipe"];
                [e setObject:@"Input"
                      forKey:statusKey];
                break;
            case kMMLEventOutput:
                [e setObject:[NSNumber numberWithInt:event.outputMode]
                      forKey:@"mode"];
                [e setObject:[NSNumber numberWithInt:event.outputPipe]
                      forKey:@"pipe"];
                [e setObject:@"Output"
                      forKey:statusKey];
                break;
            case kMMLEventExpression:
                [e setObject:[NSNumber numberWithInt:event.outputPipe]
                      forKey:@"expression"];
                [e setObject:@"Expression"
                      forKey:statusKey];
                break;
            case kMMLEventRingModulate:
                [e setObject:[NSNumber numberWithInt:event.ringSens]
                      forKey:@"sens"];
                [e setObject:[NSNumber numberWithInt:event.ringPipe]
                      forKey:@"pipe"];
                [e setObject:@"RingModulate"
                      forKey:statusKey];
                break;
            case kMMLEventSync:
                [e setObject:[NSNumber numberWithInt:event.syncMode]
                      forKey:@"mode"];
                [e setObject:[NSNumber numberWithInt:event.syncPipe]
                      forKey:@"pipe"];
                [e setObject:@"Sync"
                      forKey:statusKey];
                break;
            case kMMLEventClose:
                [e setObject:@"Close"
                      forKey:statusKey];
                break;
            case kMMLEventEot:
                [e setObject:@"Eot"
                      forKey:statusKey];
                break;
            case kMMLEventNop:
                [e setObject:@"Nop"
                      forKey:statusKey];
            default:
                [e setObject:@"Unknown"
                      forKey:statusKey];
                break;
        }
        [r addObject:e];
    }
    return r;
}

@end
