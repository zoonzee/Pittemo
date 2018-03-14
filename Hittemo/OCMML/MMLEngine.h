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
//  MMLEngine.h
//  OCMML
//
//  Created by hkrn on 09/02/06.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLFormant.h"
#import "MMLTrack.h"
#import "MMLSequencer.h"

FOUNDATION_EXPORT NSString *const MMLEngineDidCompile;
FOUNDATION_EXPORT NSString *const MMLEngineDidResume;

enum MMLEngineWarningType {
    kMMLEngineWarningUnknownCommand,
    kMMLEngineWarningUnclosedRepeat,
    kMMLEngineWarningUnopenedComment,
    kMMLEngineWarningUnclosedComment
};

@interface MMLEngine : NSObject
{
    MMLSequencer *m_sequencer;
    enum MMLOscillatorType m_form;
    NSMutableArray *m_tracks;
    NSMutableArray *m_warnings;
    NSMutableString *m_string;
    NSUInteger m_stringLocation;
    NSOperationQueue *m_queue;
    BOOL m_isRelativeDir;
    BOOL m_velocityDetail;
    BOOL m_isKeyOff;
    BOOL m_compiling;
    int m_trackNo;
    int m_octave;
    int m_velocity;
    int m_length;
    int m_tempo;
    int m_gate;
    int m_maxGate;
    int m_noteShift;
    int m_maxPipe;
    int m_maxSyncSource;
}

- (void)play:(NSString *)string;
- (void)stop;
- (void)pause;
- (void)resume;

@property(readonly) unsigned int globalTick;
@property(readonly) BOOL isPlaying;
@property(readonly) BOOL isPaused;
@property(readonly) NSArray *warnings;
@property(readonly) NSUInteger duration;
@property(readonly) NSUInteger timespan;
@property int masterVolume;
@property(readonly) MMLSequencer *m_sequencer;
@property(readonly) NSMutableString *m_string;
@property(readonly) BOOL m_compiling;

@end
