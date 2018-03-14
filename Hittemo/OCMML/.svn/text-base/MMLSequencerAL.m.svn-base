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
//  MMLSequencerAL.m
//  OCMML
//
//  Created by hkrn on 09/02/08.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLSequencerAL.h"

@implementation MMLSequencerAL

- (id)initWithMultiple:(unsigned int)aMultiple
{
    self = [super initWithMultiple:aMultiple];
    if (self != nil) {
        int size = (kBufferSize * m_multiple) << 1;
        m_device = alcOpenDevice(NULL);
        m_context = alcCreateContext(m_device, NULL);
        alcMakeContextCurrent(m_context);
        m_bufferInShort = malloc(sizeof(short) * size);
        m_alFormat = AL_FORMAT_STEREO16;
        alGetError();
        alGenBuffers(2, m_alBuffers);
        ALenum error = alGetError();
        if (error != AL_NO_ERROR) {
            return nil;
        }
        alGenSources(1, &m_alSource);
        error = alGetError();
        if (error != AL_NO_ERROR) {
            return nil;
        }
        m_endCount = 0;
        m_queue = [[NSOperationQueue alloc] init];
        [m_queue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)emptyBuffers
{
    int queued = 0;
    alSourceStop(m_alSource);
    alGetSourcei(m_alSource, AL_BUFFERS_QUEUED, &queued);
    while (queued-- > 0) {
        ALuint buffer;
        alSourceUnqueueBuffers(m_alSource, 1, &buffer);
        ALenum error = alGetError();
        if (error != AL_NO_ERROR) {
            break;
        }
    }
}

- (void)dealloc
{
    [self emptyBuffers];
    [m_queue release];
    free(m_bufferInShort);
    alDeleteSources(1, &m_alSource);
    alDeleteBuffers(2, m_alBuffers);
    alcMakeContextCurrent(NULL);
    alcDestroyContext(m_context);
    alcCloseDevice(m_device);
    [super dealloc];
}

#if CGFLOAT_IS_DOUBLE
#define kSampleRate 22050.0 // 44100.0
#else
#define kSampleRate 22050.0f // 44100.0f
#endif

- (BOOL)getSample:(ALuint)alBuffer
{
    int processOffset = 0;
    m_step = kMMLSequencerStepPre;
    
    MMLTrack *track = [m_tracks objectAtIndex:kTempoTrack];
    if ([track isEnd]) {
        m_endCount++;
        if (m_endCount > 1) {
            m_status = kMMLSequencerStatusLast;
            return NO;
        }
    }
    
    int slen = kBufferSize * m_multiple;
    int blen = MIN((kBufferSize << 2), slen);
    NSInteger nlen = [m_tracks count];
    int processTrack = 0;
    CGFloat *buffer = m_buffers[1 - m_playSide];
    
    while (YES) {
        switch (m_step) {
            case kMMLSequencerStepPre:
                for (int i = (slen << 1) - 1; i >= 0; i--) {
                    buffer[i] = 0;
                }
                if (nlen > 0) {
                    track = [m_tracks objectAtIndex:kTempoTrack];
                    [track getSamples:buffer
                                start:0
                                  end:slen];
                }
                processTrack = kFirstTrack;
                processOffset = 0;
                m_step = kMMLSequencerStepTrack;
                break;
            case kMMLSequencerStepTrack:
                if (processTrack >= nlen) {
                    m_step = kMMLSequencerStepPost;
                }
                else {
                    track = [m_tracks objectAtIndex:processTrack];
                    [track getSamples:buffer
                                start:processOffset
                                  end:processOffset + blen];
                    processOffset += blen;
                    if (processOffset >= slen) {
                        processOffset = 0;
                        ++processTrack;
//                        if (m_status == kMMLSequencerStatusBuffering) {
//                            CGFloat value = (processTrack + 1.0f) / (nlen + 1.0f);
//                            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                            NSNumber *percent = [NSNumber numberWithDouble:value];
//                            NSNumber *eob = [NSNumber numberWithBool:value >= 1 ? YES : NO];
//                            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:percent,
//                                                      @"progress", eob, @"eob", nil];
//                            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//                            [center postNotificationName:MMLSequencerDidBuffer
//                                                  object:self
//                                                userInfo:userInfo];
//                            [pool release];
//                        }
                    }
                }
                break;
            case kMMLSequencerStepPost:
//				NSLog(@"kMMLSequencerStepPost");
                m_step = kMMLSequencerStepComplete;
                m_playSide = 1 - m_playSide;
                if (m_status == kMMLSequencerStatusBuffering) {
                    m_status = kMMLSequencerStatusPlay;
                }
                slen <<= 1;
#define kAmplitude 32767 // 16384,32767
                for (int i = 0; i < slen; i++) {
                    m_bufferInShort[i] = (short)(buffer[i] * kAmplitude);
                }
                alBufferData(alBuffer, m_alFormat, m_bufferInShort, slen << 1, kSampleRate);
                return YES;
            default:
                return NO;
        }
    }
    
    return YES;
}

- (BOOL)canPause
{
    for (int i = 0; i < 2; i++) {
        if (![self getSample:m_alBuffers[i]]) {
            return NO;
        }
    }
    alSourceQueueBuffers(m_alSource, 2, m_alBuffers);
    alSourcePlay(m_alSource);
    m_status = kMMLSequencerStatusPlay;
    return YES;
}

- (BOOL)update
{
//    if (self.status == kMMLSequencerStatusStop)
//        return NO;
	
	if (self.status == kMMLSequencerStatusStop) {
        m_status = kMMLSequencerStatusBuffering;
        [self canPause];
	}
	
    ALint n = 0, state = 0;
    BOOL active = YES;
    alGetSourcei(m_alSource, AL_BUFFERS_PROCESSED, &n);
    if (n > 0) {
        ALuint buffer = 0;
        alSourceUnqueueBuffers(m_alSource, 1, &buffer);
        ALenum error = alGetError();
        if (error != AL_NO_ERROR) {
            return NO;
        }
        alGetSourcei(m_alSource, AL_SOURCE_STATE, &state);
        if (state != AL_PLAYING) {
            m_status = kMMLSequencerStatusBuffering;
        }
        active = [self getSample:buffer];
        alSourceQueueBuffers(m_alSource, 1, &buffer);
        error = alGetError();
        if (error != AL_NO_ERROR) {
            return NO;
        }
        if (state != AL_PLAYING) {
            alSourcePlay(m_alSource);
        }
    }
    return active;
}

- (void)pause
{
    alSourcePause(m_alSource);
}

- (void)stop
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [super stop];
    [self emptyBuffers];
    [pool release];
    alSourceRewind(m_alSource);
    m_endCount = 0;
}

//- (void)render
//{
//    ALenum state = 0;
//    alGetSourcei(m_alSource, AL_SOURCE_STATE, &state);
//    if (state == AL_PAUSED) {
//        self.status = kMMLSequencerStatusPlay;
//        alSourcePlay(m_alSource);
//    }
//    else {
//        m_status = kMMLSequencerStatusBuffering;
//        [self canPause];
//    }
//    while ([self update]) {
//        alGetSourcei(m_alSource, AL_SOURCE_STATE, &state);
//        if (state == AL_PAUSED) {
//            // interrupted
//            self.status = kMMLSequencerStatusPause;
//            return;
//        }
//        NSDate *dateToWait = [[NSDate alloc] initWithTimeIntervalSinceNow:0.015];
//        [NSThread sleepUntilDate:dateToWait];
//        [dateToWait release];
//    }
//}
//
//- (void)play
//{
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
//                                                                            selector:@selector(render)
//                                                                              object:nil];
//    [m_queue addOperation:operation];
//    [operation release];
//}

@end
