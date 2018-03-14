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
//  MMLSequencer.h
//  OCMML
//
//  Created by hkrn on 09/02/08.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLChannel.h"
#import "MMLTrack.h"

#define kBufferSize 8192
#define kBufferArraySize 2
#define kSignalArraySize 3

//FOUNDATION_EXPORT NSString *const MMLSequencerDidBuffer;
FOUNDATION_EXPORT NSString *const MMLSequencerDidStop;

enum MMLSequencerStatusType {
    kMMLSequencerStatusStop,        // 0
    kMMLSequencerStatusPause,        // 1
    kMMLSequencerStatusBuffering,    // 2
    kMMLSequencerStatusPlay,        // 3
    kMMLSequencerStatusLast            // 4
};

enum MMLStepType {
    kMMLSequencerStepNone,        // 0
    kMMLSequencerStepPre,        // 1
    kMMLSequencerStepTrack,        // 2
    kMMLSequencerStepPost,        // 3
    kMMLSequencerStepComplete    // 4
};

@interface MMLSequencer : NSObject
{
    CGFloat *m_buffers[kBufferArraySize];
    NSMutableArray *m_tracks;
    NSUInteger m_timespan;
    unsigned int m_multiple;
    enum MMLSequencerStatusType m_status;
    enum MMLStepType m_step;
    unsigned int m_globalTick;
    float m_phase;
    int m_playSide;
    CGFloat m_soundVolume;
}

- (id)initWithMultiple:(unsigned int)multiple;
- (void)play;
- (void)stop;
- (void)pause;
- (void)disconnectAllTracks;
- (void)connectTrack:(MMLTrack *)track;
- (void)createPipes:(int)number;
- (void)createSyncSource:(int)number;
- (BOOL)update;

@property(readonly) BOOL isPlaying;
@property(readonly) BOOL isPaused;
@property(readonly) unsigned int globalTick;
@property(readonly) NSUInteger timespan;
@property int masterVolume;
@property enum MMLSequencerStatusType status;

@end
