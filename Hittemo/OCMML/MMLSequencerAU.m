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
//  MMLSequencerAU.m
//  OCMML
//
//  Created by hkrn on 09/02/08.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLSequencerAU.h"

#define kMMLSequencerNanoToMil 1000000

@implementation MMLSequencerAU

@synthesize m_output;
@synthesize m_processOffset;
//@synthesize m_playSide;
@synthesize m_playSize;
//@synthesize m_soundVolume;
//@synthesize m_step;

static OSStatus RenderCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    OSStatus err;
    err = [(id)inRefCon render:inNumberFrames
                        ioData:ioData
                    ioActionFlags:ioActionFlags
                    inTimeStamp:inTimeStamp
                    inBusNumber:inBusNumber];
    [pool release];
    return err;
}

- (id)initWithMultiple:(NSUInteger)multiple
{
    self = [super initWithMultiple:multiple];
    if (self != nil) {
        m_output = NO;
        m_playSide = m_playSize = m_dataSize = 0;
        m_step = kMMLSequencerStepNone;
#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
        AudioComponentDescription desc;
        desc.componentSubType = kAudioUnitSubType_RemoteIO;
#else
        ComponentDescription desc;
        desc.componentSubType = kAudioUnitSubType_DefaultOutput;
#endif
        desc.componentType = kAudioUnitType_Output;
        desc.componentManufacturer = kAudioUnitManufacturer_Apple;
        desc.componentFlags = 0;
        desc.componentFlagsMask = 0;
        AudioUnitInitialize(m_audioUnit);
#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
        AudioComponent component = AudioComponentFindNext(NULL, &desc);
        AudioComponentInstanceNew(component, &m_audioUnit);
#else
        Component component = FindNextComponent(NULL, &desc);
        OpenAComponent(component, &m_audioUnit);
#endif
        AURenderCallbackStruct input;
        input.inputProc = RenderCallback;
        input.inputProcRefCon = self;
        AudioUnitSetProperty(m_audioUnit,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Input,
                             0,
                             &input,
                             sizeof(input));
        AudioUnitInitialize(m_audioUnit);
        [self setMasterVolume:100];
    }
    return self;
}

- (void)dealloc
{
    AudioOutputUnitStop(m_audioUnit);
    AudioUnitUninitialize(m_audioUnit);
#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
    AudioComponentInstanceDispose(m_audioUnit);
#else
    CloseComponent(m_audioUnit);
#endif
    m_audioUnit = NULL;
    [super dealloc];
}

static inline void SleepProcessThread()
{
    NSDate *dateToWait = [[NSDate alloc] initWithTimeIntervalSinceNow:kMMLSequencerTimerDelayOfProcess];
    [NSThread sleepUntilDate:dateToWait];
    [dateToWait release];
}

- (void)process
{
//    int slen = kBufferSize * m_multiple;
//    int blen = MIN((kBufferSize << 2), slen);
//    while ([self isPlaying]) {
//        BOOL isOutput = self.m_output;
//        enum MMLSequencerStatusType currentStatus = self.status;
//        int currentPlaySide = self.m_playSide;
//        int nlen = [m_tracks count];
//        CGFloat *buffer = m_buffers[1 - currentPlaySide];
//        switch (self.m_step) {
//            case kMMLSequencerStepPre:
//                if (isOutput) {
//                    SleepProcessThread();
//                    continue;
//                }
//                for (int i = (slen << 1) - 1; i >= 0; i--) {
//                    buffer[i] = 0;
//                }
//                if (nlen > 0) {
//                    MMLTrack *track = [m_tracks objectAtIndex:kTempoTrack];
//                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                    [track getSamples:buffer
//                                start:0
//                                  end:slen
//                               signal:m_signals[m_signalIndex]];
//                    [pool release];
//                }
//                self.m_processOffset = 0;
//                self.m_step = kMMLSequencerStepTrack;
//                m_processTrack = kFirstTrack;
//                SleepProcessThread();
//                break;
//            case kMMLSequencerStepTrack:
//                if (isOutput) {
//                    SleepProcessThread();
//                    continue;
//                }
//                if (m_processTrack >= nlen) {
//                    self.m_step = kMMLSequencerStepPost;
//                }
//                else {
//                    int startOffset = self.m_processOffset;
//                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                    MMLTrack *track = [m_tracks objectAtIndex:m_processTrack];
//                    [track getSamples:buffer
//                                start:startOffset
//                                  end:startOffset + blen
//                               signal:nil];
//                    self.m_processOffset = startOffset = startOffset + blen;
//                    if (startOffset >= slen) {
//                        self.m_processOffset = 0;
//                        ++m_processTrack;
//                        if (currentStatus == kMMLSequencerStatusBuffering) {
//                            CGFloat value = (m_processTrack + 1.0) / (nlen + 1.0);
//                            NSNumber *eob = [NSNumber numberWithBool:value >= 1 ? YES : NO];
//                            NSNumber *percent = [NSNumber numberWithDouble:value];
//                            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:percent,
//                                                      @"progress", eob, @"eob", nil];
//                            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//                            [center postNotificationName:MMLSequencerDidBuffer
//                                                  object:self
//                                                userInfo:userInfo];
//                        }
//                    }
//                    [pool release];
//                }
//                SleepProcessThread();
//                break;
//            case kMMLSequencerStepPost:
//                self.m_step = kMMLSequencerStepComplete;
//                if (currentStatus == kMMLSequencerStatusBuffering) {
//                    self.status = kMMLSequencerStatusPlay;
//                    self.m_playSide = 1 - currentPlaySide;
//                    self.m_playSize = self.m_processOffset = 0;
//                    self.m_step = kMMLSequencerStepPre;
//                    m_startAt = 0;
//                    AudioOutputUnitStart(m_audioUnit);
//                }
//                SleepProcessThread();
//                break;
//            default:
//                if (currentStatus != kMMLSequencerStatusLast) {
//                    SleepProcessThread();
//                }
//                else {
//                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//                    [self stop];
//                    [center postNotificationName:MMLSequencerDidStop
//                                          object:self
//                                        userInfo:nil];
//                    [pool release];
//                    [NSThread exit];
//                    return;
//                }
//                break;
//        }
//    }
//    [NSThread exit];
//    return;
}

- (OSStatus)render:(UInt32)inNumberFrames 
            ioData:(AudioBufferList *)ioData
     ioActionFlags:(AudioUnitRenderActionFlags *)ioActionFlags
       inTimeStamp:(const AudioTimeStamp *)inTimeStamp
       inBusNumber:(UInt32)inBusNumber
{
//#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
//    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
//    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
//#else
//    float *outL = ioData->mBuffers[0].mData;
//    float *outR = ioData->mBuffers[1].mData;
//#endif
//    self.m_output = YES;
//    
//    UInt64 nanosec = AudioConvertHostTimeToNanos(inTimeStamp->mHostTime);
//    if (m_startAt == 0 && m_timespan > 0) {
//        m_startAt = nanosec - (m_timespan * kMMLSequencerNanoToMil);
//    }
//    else if (m_startAt == 0) {
//        m_startAt = nanosec;
//    }
//    m_timespan = (unsigned int)((nanosec - m_startAt) / kMMLSequencerNanoToMil);
//    
//    if (self.m_playSize >= m_multiple * (kBufferSize / inNumberFrames)) {
//        if (self.m_step == kMMLSequencerStepComplete) {
//            self.m_playSide = 1 - self.m_playSide;
//            self.m_playSize = self.m_processOffset = 0;
//            self.m_step = kMMLSequencerStepPre;
//        }
//        else {
//            self.m_output = NO;
//            self.status = kMMLSequencerStatusBuffering;
//            for (NSUInteger i = 0; i < inNumberFrames; i++) {
//                *outL++ = *outR++ = 0;
//            }
//            AudioOutputUnitStop(m_audioUnit);
//            return noErr;
//        }
//        enum MMLSequencerStatusType currentStatus = self.status;
//        if (currentStatus == kMMLSequencerStatusLast) {
//            self.m_output = NO;
//            for (NSUInteger i = 0; i < inNumberFrames; i++) {
//                *outL++ = *outR++ = 0;
//            }
//            [self stop];
//            return noErr;
//        }
//        else if (currentStatus == kMMLSequencerStatusPlay) {
//            MMLTrack *track = [m_tracks objectAtIndex:kTempoTrack];
//            if ([track isEnd]) {
//                self.status = kMMLSequencerStatusLast;
//            }
//        }
//    }
//    
//    CGFloat *buffer = m_buffers[m_playSide];
//    CGFloat volume = self.m_soundVolume;
//    int base = (inNumberFrames * self.m_playSize) << 1;
//    for (NSUInteger i = 0; i < inNumberFrames; i++) {
//        int n = base + (i << 1);
//#if TARGET_OS_IPHONE || MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
//        float max = 1 << kAudioUnitSampleFractionBits;
//        *outL++ = (AudioUnitSampleType)(buffer[n] * max * volume);
//        *outR++ = (AudioUnitSampleType)(buffer[n + 1] * max * volume);
//#else
//        *outL++ = (float)(buffer[n] * volume);
//        *outR++ = (float)(buffer[n + 1] * volume);
//#endif
//        /*
//         if (i == 0) {
//         NSLog(@"%d:%d:%0.3f:%0.3f", i, base, *outL, *outR);
//         }
//         //*/
//    }
//    
//    ++self.m_playSize;
//    m_signalIndex = ++m_signalIndex % kSignalArraySize;
//    self.m_output = NO;
    
    return noErr;
}

- (void)play
{
    if (m_status != kMMLSequencerStatusPause) {
        m_globalTick = 0;
        NSUInteger trackCount = [m_tracks count];
        for (NSUInteger i = 0; i < trackCount; i++) {
            MMLTrack *track = [m_tracks objectAtIndex:i];
            [track seekHead];
        }
        m_status = kMMLSequencerStatusBuffering;
        m_step = kMMLSequencerStepPre;
        m_processOffset = m_timespan = 0;
        [self performSelectorInBackground:@selector(process)
                               withObject:nil];
    }
    else {
        m_status = kMMLSequencerStatusPlay;
        [self performSelectorInBackground:@selector(process)
                               withObject:nil];
    }
}

- (void)pause
{
    AudioOutputUnitStop(m_audioUnit);
    [super pause];
}

- (void)stop
{
    AudioOutputUnitStop(m_audioUnit);
    [super stop];
}

- (unsigned int)duration
{
    MMLTrack *track = [m_tracks objectAtIndex:kTempoTrack];
    return track.duration;
}

@end
