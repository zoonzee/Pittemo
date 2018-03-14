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
//  MMLSequencer.m
//  OCMML
//
//  Created by hkrn on 09/02/08.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLSequencer.h"

@implementation MMLSequencer

//NSString *const MMLSequencerDidBuffer = @"MMLSequencerDidBuffer";
NSString *const MMLSequencerDidStop = @"MMLSequencerDidStop";

@synthesize masterVolume;

- (id)initWithMultiple:(unsigned int)multiple
{
    self = [super init];
    if (self != nil) {
        m_tracks = [[NSMutableArray alloc] init];
        m_multiple = multiple;
        m_status = kMMLSequencerStatusStop;
        for (int i = 0; i < kBufferArraySize; i++) {
            int size = (kBufferSize * multiple) << 1;
            m_buffers[i] = malloc(sizeof(CGFloat) * size);
            if (m_buffers[i] == NULL)
                return nil;
        }
        [MMLChannel initializeWithSamples:kBufferSize * multiple];
    }
    return self;
}

- (void)dealloc
{
    [m_tracks release];
    for (int i = 0; i < kBufferArraySize; i++) {
        CGFloat *buffer = m_buffers[i];
        free(buffer);
    }
    [super dealloc];
}

- (void)setMasterVolume:(int)volume
{
    volume = MIN(MAX(volume, 0), 127);
    m_soundVolume = volume *
#if CGFLOAT_IS_DOUBLE
    (1.0f / 127.0f);
#else
    (1.0f / 127.0f);
#endif
}

// todo 使っていない
- (int)masterVolume
{
    return (int)(m_soundVolume * 127);
}

- (void)play
{
}

- (void)pause
{
    self.status = kMMLSequencerStatusPause;
}

- (void)stop
{
    self.status = kMMLSequencerStatusStop;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:MMLSequencerDidStop
                          object:self
                        userInfo:nil];
}

- (void)disconnectAllTracks
{
    [m_tracks removeAllObjects];
    self.status = kMMLSequencerStatusStop;
}

- (void)connectTrack:(MMLTrack *)track
{
    [m_tracks addObject:track];
}

- (void)createPipes:(int)number
{
    [MMLChannel createPipes:number];
}

- (void)createSyncSource:(int)number
{
    [MMLChannel createSyncSources:number];
}

- (BOOL)isPlaying
{
    return self.status > kMMLSequencerStatusPause;
}

- (BOOL)isPaused
{
    return self.status == kMMLSequencerStatusPause;
}

- (unsigned int)globalTick
{
    return m_globalTick;
}

- (enum MMLSequencerStatusType)status
{
    return m_status;
}

- (void)setStatus:(enum MMLSequencerStatusType)status
{
    m_status = status;
}

- (NSUInteger)timespan
{
    return m_timespan;
}

- (BOOL)update
{
	return NO;
}

@end
