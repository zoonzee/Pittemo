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
//  MMLChannel.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Oscillators.h"
#import "MMLChannel.h"
#import "MMLChannel+Private.h"

@implementation MMLChannel

#if 0
- (void)validateSamples:(CGFloat *)aSamples
                  start:(int)start
                    end:(int)end
{
    for (int i = start; i < end; i++) {
        if (aSamples[i] == NAN || aSamples[i] > 5 || aSamples[i] < -5) {
            NSLog(@"%.05f", aSamples[i]);
            NSException *exception = [NSException exceptionWithName:NSRangeException
                                                             reason:@"NaN has found"
                                                           userInfo:nil];
            @throw exception;
        }
    }
}
#define VALIDATE_SAMPLES(aSamples, s, e) \
    [self validateSamples:aSamples start:s end:e]
#else
#define VALIDATE_SAMPLES(aSamples, start, end)
#endif

- (id)init
{
    self = [super init];
    if (self != nil) {
        m_noteNo = 0;
        m_detune = 0;
        m_frequencyNo = 0;
        CGFloat attack = 0, decay = 0, sustain = 0, release = 0;
#if CGFLOAT_IS_DOUBLE
        attack = 0.0;
        decay = 60.0 / 127.0;
        sustain = 30.0 / 127.0;
        release = 1.0 / 127.0;
#else
        attack = 0.0f;
        decay = 60.0f / 127.0f;
        sustain = 30.0f / 127.0f;
        release = 1.0f / 127.0f;
#endif
        m_envelope4VCO = [[MMLEnvelope alloc] initWithAttack:attack
                                                       decay:decay
                                                     sustain:sustain
                                                     release:release];
#if CGFLOAT_IS_DOUBLE
        decay = 30.0 / 127.0;
        sustain = 0.0;
        release = 1.0;
#else
        decay = 30.0f / 127.0f;
        sustain = 0.0f;
        release = 1.0f;
#endif
        m_envelope4VCF = [[MMLEnvelope alloc] initWithAttack:attack
                                                       decay:decay
                                                     sustain:sustain
                                                     release:release];
        m_set1 = [[MMLOscillator alloc] init];
        m_mod1 = m_set1.currentModulator;
        m_set2 = [[MMLOscillator alloc] init];
        [m_set2 asLFO];
        m_set2.form = kMMLOscillatorSine;
        m_mod2 = m_set2.currentModulator;
        m_osc2connect = NO;
        m_filter = [[MMLFilter alloc] init];
        m_filterConnect = 0;
        m_formant = [[MMLFormant alloc] init];
        [self setPan:64];
        m_onCounter = 0;
        m_lfoDelay = 0;
        m_lfoDepth = 0;
        m_lfoEnd = 0;
        m_lpfAmount = 0;
        m_lpfFrequency = 0;
        m_lpfResonance = 0;
        m_volumeMode = 0;
        [self setVelocity:100];
        [self setExpression:127];
        [self setInput:0
                  pipe:0];
        [self setOutput:0
                   pipe:0];
        [self setRingSens:0
                     pipe:0];
        [self setSyncMode:0
                     pipe:0];
    }
    return self;
}

- (void)dealloc
{
    [m_envelope4VCO release];
    [m_envelope4VCF release];
    [m_set1 release];
    [m_set2 release];
    [m_filter release];
    [m_formant release];
    [super dealloc];
}

- (void)setNoteNumber:(int)number
{
    m_noteNo = number;
    [self setFrequency:number];
}

- (void)setDetune:(int)detune
{
    m_detune = detune;
    [self setFrequency:m_noteNo];
}

- (void)enableNoteAtNumber:(int)number
                  velocity:(int)velocity
{
    [self setNoteNumber:number];
    [m_envelope4VCO triggerWithZeroStart:NO];
    [m_envelope4VCF triggerWithZeroStart:YES];
    [m_mod1 resetPhase];
    [m_mod2 resetPhase];
    [m_filter reset];
    [self setVelocity:velocity];
    m_onCounter = 0;
    FCNoise *fcNoise = (FCNoise *)[m_set1 modulatorFromForm:kMMLOscillatorFCNoise];
    [fcNoise setNoiseFrequency:number];
    GBLongNoise *gblNoise = (GBLongNoise *)[m_set1 modulatorFromForm:kMMLOscillatorGBLongNoise];
    [gblNoise setNoiseFrequency:number];
    GBShortNoise *gbsNoise = (GBShortNoise *)[m_set1 modulatorFromForm:kMMLOscillatorGBShortNoise];
    [gbsNoise setNoiseFrequency:number];
    FCDPCM *fcDPCM = (FCDPCM *)[m_set1 modulatorFromForm:kMMLOscillatorFCDPCM];
    [fcDPCM setDPCMFrequency:number];
}

- (void)setFrequency:(int)number
{
    m_frequencyNo = number * kPitchResolution + m_detune;
    m_mod1.frequency = [[self class] frequencyWithNumber:m_frequencyNo];
}

- (void)disableNote
{
    [m_envelope4VCO releaseEnvelope];
    [m_envelope4VCF releaseEnvelope];
}

- (void)close
{
    [self disableNote];
    [m_filter setSwitch:0];
}

- (void)setNoiseFrequency:(CGFloat)frequency
{
    Noise *noise = (Noise *)[m_set1 modulatorFromForm:kMMLOscillatorNoise];
    CGFloat n = 0;
#if CGFLOAT_IS_DOUBLE
    n = 1.0 - frequency * (1.0 / 128.0);
#else
    n = 1.0f - frequency * (1.0f / 128.0f);
#endif
    [noise setNoiseFrequency:n];
}

- (void)setForm:(enum MMLOscillatorType)form
        subform:(enum MMLOscillatorType)subForm
{
    [m_set1 setForm:form];
    m_mod1 = [m_set1 modulatorFromForm:form];
    if (form == kMMLOscillatorGBWave) {
        GBWave *gbWave = (GBWave *)[m_set1 modulatorFromForm:kMMLOscillatorGBWave];
        [gbWave setWaveIndex:subForm];
    }
    if (form == kMMLOscillatorFCDPCM) {
        FCDPCM *fcDPCM = (FCDPCM *)[m_set1 modulatorFromForm:kMMLOscillatorFCDPCM];
        [fcDPCM setWaveIndex:subForm];
    }
}

#if CGFLOAT_IS_DOUBLE
#define N1_DIV_127 (1.0 / 127.0)
#else
#define N1_DIV_127 (1.0f / 127.0f)
#endif

- (void)setEnvelopeForVCOWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release
{
    [m_envelope4VCO setAttack:attack * N1_DIV_127
                        decay:decay * N1_DIV_127
                      sustain:sustain * N1_DIV_127
                      release:release * N1_DIV_127];
}

- (void)setEnvelopeForVCFWithAttack:(int)attack
                              decay:(int)decay
                            sustain:(int)sustain
                            release:(int)release
{
    [m_envelope4VCF setAttack:attack * N1_DIV_127
                        decay:decay * N1_DIV_127
                      sustain:sustain * N1_DIV_127
                      release:release * N1_DIV_127];
}

- (void)setPWM:(int)pwm {
    CGFloat n = 0;
    Pulse *pulse = NULL;
    if (m_set1.form != kMMLOscillatorFCPulse) {
#if CGFLOAT_IS_DOUBLE
        n = 1.0 / 100.0;
#else
        n = 1.0f / 100.0f;
#endif
        pulse = (Pulse *)[m_set1 modulatorFromForm:kMMLOscillatorPulse];
        [pulse setPWM:pwm * n];
    }
    else {
#if CGFLOAT_IS_DOUBLE
        n = 0.125;
#else
        n = 0.125f;
#endif
        pulse = (Pulse *)[m_set1 modulatorFromForm:kMMLOscillatorFCPulse];
        [pulse setPWM:pwm * n];
    }
}

- (void)setPan:(int)pan {
#if CGFLOAT_IS_DOUBLE
    m_panRight = MAX((pan - 1) * (0.25 / 63.0), 0);
    m_panLeft = (2.0 * 0.25) - m_panRight;
#else
    m_panRight = MAX((pan - 1) * (0.25f / 63.0f), 0);
    m_panLeft = (2.0f * 0.25f) - m_panRight;
#endif
}

- (void)setFormantVowel:(enum MMLFormantVowelType)vowel {
    if (vowel >= 0) {
        m_formant.vowel = vowel;
    }
    else {
        [m_formant disable];
    }
}

- (void)setLFOForm:(enum MMLOscillatorType)form
           subform:(enum MMLOscillatorType)subform
             depth:(int)depth
         frequency:(CGFloat)frequency
             delay:(int)delay
              time:(int)aTime
           reverse:(BOOL)reverse
{
    enum MMLOscillatorType mainForm = form - 1;
    [m_set2 setForm:mainForm];
    m_mod2 = [m_set2 modulatorFromForm:mainForm];
#if CGFLOAT_IS_DOUBLE
    m_osc2sign = reverse ? -1.0 : 1.0;
#else
    m_osc2sign = reverse ? -1.0f : 1.0f;
#endif
    if (mainForm >= kMMLOscillatorMax) {
        m_osc2connect = NO;
    }
    if (mainForm == kMMLOscillatorGBWave) {
        GBWave *gbWave = (GBWave *)[m_set2 modulatorFromForm:kMMLOscillatorGBWave];
        [gbWave setWaveIndex:subform];
    }
    m_lfoDepth = depth;
    m_osc2connect = depth == 0 ? NO : YES;
    [m_mod2 setFrequency:frequency];
    [m_mod2 resetPhase];
    Noise *noise = (Noise *)[m_set2 modulatorFromForm:kMMLOscillatorNoise];
    [noise setNoiseFrequency:frequency / kSampleRate];
    m_lfoDelay = delay;
    m_lfoEnd = aTime > 0 ? m_lfoDelay + aTime : 0;
}

- (void)setLPFSwitch:(enum MMLFilterType)aSwitch
              amount:(int)amount
           frequency:(int)frequency
           resonance:(int)resonance
{
    if (aSwitch >= kMMLFilterHPFQuality && aSwitch <= kMMLFilterLPFQuality && aSwitch != m_filterConnect) {
        m_filterConnect = aSwitch;
        [m_filter setSwitch:aSwitch];
    }
    m_lpfAmount = MIN(MAX(amount, -127), 127);
    m_lpfAmount *= kPitchResolution;
    frequency = MIN(MAX(frequency, 0), 127);
    m_lpfFrequency = frequency * kPitchResolution;
    m_lpfResonance = resonance * N1_DIV_127;
#if CGFLOAT_IS_DOUBLE
    m_lpfResonance = MIN(MAX(m_lpfResonance, 0.0), 1.0);
#else
    m_lpfResonance = MIN(MAX(m_lpfResonance, 0.0f), 1.0f);
#endif
}

#undef N1_DIV_127

- (void)setVolumeMode:(int)mode
{
    m_volumeMode = mode;
}

- (void)setInput:(int)input
            pipe:(int)inPipe
{
    CGFloat n = 0;
#if CGFLOAT_IS_DOUBLE
    n = 1.0 / 8.0;
#else
    n = 1.0f / 8.0f;
#endif
    m_inSens = (1 << (input - 1)) * n * kPhaseLength;
    m_inPipe = inPipe;
}

- (void)setOutput:(enum MMLChannelOutputMode)output
             pipe:(int)outPipe
{
    m_outMode = output;
    m_outPipe = MIN(MAX(outPipe, 0), s_pipeArrayNumber);
}

#if CGFLOAT_IS_DOUBLE
#define N127 127.0
#else
#define N127 127.0f
#endif

- (void)setVelocity:(int)velocity
{
    velocity = MIN(MAX(velocity, 0), 127);
    m_velocity = m_volumeMode ? s_volumeMap[velocity] : velocity / N127;
    m_ampLevel = m_velocity * m_expression;
}

- (void)setExpression:(int)expression
{
    expression = MIN(MAX(expression, 0), 127);
    m_expression = m_volumeMode ? s_volumeMap[expression] : expression / N127;
    m_ampLevel = m_velocity * m_expression;
}

- (void)setRingSens:(int)sens
               pipe:(int)aPipe
{
    m_ringSens = (1 << (sens - 1)) /
#if CGFLOAT_IS_DOUBLE
    8.0;
#else
    8.0f;
#endif
    m_ringPipe = aPipe;
}

- (void)setSyncMode:(enum MMLChannelOutputMode)mode
               pipe:(int)aPipe
{
    m_syncMode = mode;
    m_syncPipe = aPipe;
}

- (CGFloat)nextCutOff
{
    CGFloat cut = m_lpfFrequency + m_lpfAmount * m_envelope4VCF.nextAmplitudeLinear;
    CGFloat n = 0;
#if CGFLOAT_IS_DOUBLE
    n = 2.0 * M_PI;
#else
    n = 2.0f * (CGFloat)M_PI;
#endif
    cut = [[self class] frequencyWithNumber:(int)cut] * m_mod1.frequency * (n / (kSampleRate * kSampleFrequencyBase));
    if (cut < (1.0 / 127.0)) {
        cut = 0;
    }
    return cut;
}

- (void)getSamples:(CGFloat *)samples
             start:(int)start
             delta:(int)delta
               max:(int)max
{
    int end = start + delta;
    int frequencyNumber = 0;
    end = MIN(end, max);
    if (!m_envelope4VCO.playing) {
        for (int i = start; i < end; i++) {
            s_samples[i] = 0;
        }
    }
    else if (m_inSens < 0.000001) {
        if (!m_osc2connect) {
            switch (m_syncMode) {
                case kMMLChannelOutputOverwrite:
                    [m_mod1 getSamples:s_samples
                               syncOut:s_syncSources[m_syncPipe]
                                 start:start
                                   end:end];
                    break;
                case kMMLChannelOutputAdd:
                    [m_mod1 getSamples:s_samples
                                syncIn:s_syncSources[m_syncPipe]
                                 start:start
                                   end:end];
                    break;
                default:
                    [m_mod1 getSamples:s_samples
                                 start:start
                                   end:end];
                    break;
            }
            VALIDATE_SAMPLES(s_samples, start, end);
            if (m_volumeMode == 0) {
                [m_envelope4VCO getAmplitudeSamplesLinear:s_samples
                                                    start:start
                                                      end:end
                                                 velocity:m_ampLevel];
            }
            else {
                [m_envelope4VCO getAmplitudeSamplesNonLinear:s_samples
                                                       start:start
                                                         end:end
                                                    velocity:m_ampLevel];
            }
        }
        else {
            int s = start;
            int e = 0;
            do {
                e = s + s_lfoDelta;
                e = MIN(e, end);
                frequencyNumber = m_frequencyNo;
                if (m_onCounter >= m_lfoDelay && (m_lfoEnd == 0 || m_onCounter < m_lfoEnd)) {
                    frequencyNumber += (int)(m_mod2.nextSample * m_osc2sign * m_lfoDepth);
                    [m_mod2 addPhase:e - s - 1];
                }
                m_mod1.frequency = [[self class] frequencyWithNumber:frequencyNumber];
                switch (m_syncMode) {
                    case kMMLChannelOutputOverwrite:
                        [m_mod1 getSamples:s_samples
                                   syncOut:s_syncSources[m_syncPipe]
                                     start:s
                                       end:e];
                        break;
                    case kMMLChannelOutputAdd:
                        [m_mod1 getSamples:s_samples
                                    syncIn:s_syncSources[m_syncPipe]
                                     start:s
                                       end:e];
                        break;
                    default:
                        [m_mod1 getSamples:s_samples
                                     start:s
                                       end:e];
                        break;
                }
                VALIDATE_SAMPLES(s_samples, s, e);
                if (m_volumeMode == 0) {
                    [m_envelope4VCO getAmplitudeSamplesLinear:s_samples
                                                        start:s
                                                          end:e
                                                     velocity:m_ampLevel];
                }
                else {
                    [m_envelope4VCO getAmplitudeSamplesNonLinear:s_samples
                                                           start:s
                                                             end:e
                                                        velocity:m_ampLevel];
                }
                m_onCounter += e - s;
                s = e;
            } while (s < end);
        }
    }
    else {
        if (!m_osc2connect) {
            m_mod1.frequency = [[self class] frequencyWithNumber:m_frequencyNo];
            for (int i = start; i < end; i++) {
                s_samples[i] = [m_mod1 nextSampleFromOffset:(int)(s_pipeArray[m_inPipe][i] * m_inSens)];
            }
            VALIDATE_SAMPLES(s_samples, start, end);
            if (m_volumeMode == 0) {
                [m_envelope4VCO getAmplitudeSamplesLinear:s_samples
                                                    start:start
                                                      end:end
                                                 velocity:m_ampLevel];
            }
            else {
                [m_envelope4VCO getAmplitudeSamplesNonLinear:s_samples
                                                       start:start
                                                         end:end
                                                    velocity:m_ampLevel];
            }
        }
        else {
            for (int i = start; i < end; i++) {
                frequencyNumber = m_frequencyNo;
                if (m_onCounter >= m_lfoDelay && (m_lfoEnd == 0 || m_onCounter < m_lfoEnd)) {
                    frequencyNumber += (int)(m_mod2.nextSample * m_osc2sign * m_lfoDepth);
                }
                m_mod1.frequency = [[self class] frequencyWithNumber:frequencyNumber];
                s_samples[i] = [m_mod1 nextSampleFromOffset:(int)(s_pipeArray[m_inPipe][i] * m_inSens)];
                m_onCounter++;
            }
            VALIDATE_SAMPLES(s_samples, start, end);
            if (m_volumeMode == 0) {
                [m_envelope4VCO getAmplitudeSamplesLinear:s_samples
                                                    start:start
                                                      end:end
                                                 velocity:m_ampLevel];
            }
            else {
                [m_envelope4VCO getAmplitudeSamplesNonLinear:s_samples
                                                       start:start
                                                         end:end
                                                    velocity:m_ampLevel];
            }
        }
    }
    if (m_ringSens >= 0.000001) {
        for (int i = start; i < end; i++) {
            s_samples[i] *= s_pipeArray[m_ringPipe][i] * m_ringSens;
        }
    }
    CGFloat key = m_mod1.frequency;
    [m_formant runWithSamples:s_samples
                        start:start
                          end:end];
    VALIDATE_SAMPLES(s_samples, start, end);
    [m_filter runWithSamples:s_samples
                       start:start
                         end:end
                    envelope:m_envelope4VCF
                   frequency:m_lpfFrequency
                      amount:m_lpfAmount
                   resonance:m_lpfResonance
                         key:key];
    VALIDATE_SAMPLES(s_samples, start, end);
    switch (m_outMode) {
        case kMMLChannelOutputDefault:
            for (int i = start; i < end; i++) {
                int n = i << 1;
                CGFloat amplitudeValue = s_samples[i];
                samples[n] += amplitudeValue * m_panLeft;
                samples[n + 1] += amplitudeValue * m_panRight;
            }
            break;
        case kMMLChannelOutputOverwrite:
            for (int i = start; i < end; i++) {
                s_pipeArray[m_outPipe][i] = s_samples[i];
            }
            break;
        case kMMLChannelOutputAdd:
            for (int i = start; i < end; i++) {
                s_pipeArray[m_outPipe][i] += s_samples[i];
            }
            break;
        default:
            break;
    }
}

+ (void)initializeWithSamples:(int)numberOfSamples
{
    static BOOL s_initialized = NO;
    if (!s_initialized) {
        int i = 0;
        s_samplesLength = numberOfSamples;
        s_samples = malloc(sizeof(CGFloat) * numberOfSamples);
        s_frequencyLength = 128 * kPitchResolution;
        for (i = 0; i < s_frequencyLength; i++) {
#if CGFLOAT_IS_DOUBLE
            s_frequencyMap[i] = kSampleFrequencyBase * pow(2.0, (i - 69.0 * kPitchResolution) / (12.0 * kPitchResolution));
#else
            s_frequencyMap[i] = kSampleFrequencyBase * powf(2.0f, (i - 69.0f * kPitchResolution) / (12.0f * kPitchResolution));
#endif
        }
        s_volumeLength = 128;
        s_volumeMap[0] = 0;
        for (i = 1; i < s_volumeLength; i++) {
#if CGFLOAT_IS_DOUBLE
            s_volumeMap[i] = pow(10.0, (i - N127) * (48.0 / (N127 * 20.0)));
#else
            s_volumeMap[i] = powf(10.0f, (i - N127) * (48.0f / (N127 * 20.0f)));
#endif
        }
        s_pipeArray = NULL;
        s_initialized = YES;
    }
}

#undef N127

+ (void)releaseChannel
{
    for (int i = 0; i < s_pipeArrayNumber; i++) {
        free(s_pipeArray[i]);
    }
    for (int i = 0; i < s_syncSourcesLength; i++) {
        free(s_syncSources[i]);
    }
    free(s_pipeArray);
    free(s_syncSources);
    free(s_samples);
}

+ (void)createPipes:(int)number
{
    s_pipeArray = malloc(sizeof(CGFloat *) * number);
    s_pipeArrayNumber = number;
    for (int i = 0; i < number; i++) {
        s_pipeArray[i] = malloc(sizeof(CGFloat) * s_samplesLength);
        for (int j = 0; j < s_samplesLength; j++) {
            s_pipeArray[i][j] = 0;
        }
    }
}

+ (void)createSyncSources:(int)number
{
    s_syncSources = malloc(sizeof(BOOL *) * number);
    s_syncSourcesLength = number;
    for (int i = 0; i < number; i++) {
        s_syncSources[i] = malloc(sizeof(BOOL) * s_samplesLength);
        for (int j = 0; j < s_samplesLength; j++) {
            s_syncSources[i][j] = NO;
        }
    }
}

+ (CGFloat)frequencyWithNumber:(int)number
{
    number = MIN(MAX(number, 0), s_frequencyLength - 1);
    return s_frequencyMap[number];
}

@end
