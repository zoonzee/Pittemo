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
//  MMLSequencerAU.h
//  OCMML
//
//  Created by hkrn on 09/03/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import <AudioUnit/AudioUnit.h>
#import "MMLSequencer.h"

#if TARGET_OS_IPHONE
#define kMMLSequencerTimerDelayOfStop (0.025)
#define kMMLSequencerTimerDelayOfBuffer (0.025)
#define kMMLSequencerTimerDelayOfProcess (0.025)
#else
#define kMMLSequencerTimerDelayOfStop (0.015)
#define kMMLSequencerTimerDelayOfBuffer (0.015)
#define kMMLSequencerTimerDelayOfProcess (0.015)
#endif

@interface MMLSequencerAU : MMLSequencer
{
@private
    BOOL m_output;
    int m_processOffset;
    int m_processTrack;
    NSUInteger m_playSize;
    NSUInteger m_dataSize;
    AudioUnit m_audioUnit;
    UInt64 m_startAt;
}

- (OSStatus)render:(UInt32)inNumberFrames
            ioData:(AudioBufferList *)ioData
     ioActionFlags:(AudioUnitRenderActionFlags *)ioActionFlags
       inTimeStamp:(const AudioTimeStamp *)inTimeStamp
       inBusNumber:(UInt32)inBusNumber;

@property BOOL m_output;
@property CGFloat m_soundVolume;
@property int m_processOffset;
@property int m_playSide;
@property NSUInteger m_playSize;
@property enum MMLStepType m_step;

@end
